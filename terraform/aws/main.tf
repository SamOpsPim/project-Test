locals {
  cost_tags = merge(
    {
      Environment = var.environment
      Owner       = var.owner
      CostCenter  = var.cost_center
      Project     = var.project_name
    },
    var.additional_tags,
  )
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "lab" {
  key_name   = "${var.project_name}-key"
  public_key = var.public_key

  tags = merge(local.cost_tags, { Name = "${var.project_name}-key" })
}

resource "aws_security_group" "lab" {
  name        = "${var.project_name}-sg"
  description = "SSH + app port 8000"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.trusted_cidr_blocks_ssh
  }

  ingress {
    description = "FastAPI lab"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = var.trusted_cidr_blocks_app
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.cost_tags, { Name = "${var.project_name}-sg" })
}

resource "aws_instance" "lab" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.lab.key_name
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.lab.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = merge(local.cost_tags, { Name = "${var.project_name}-vm" })
}

data "aws_iam_policy_document" "scheduler_assume" {
  count = var.enable_instance_schedule ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lab_scheduler" {
  count = var.enable_instance_schedule ? 1 : 0

  name               = "${var.project_name}-scheduler"
  assume_role_policy = data.aws_iam_policy_document.scheduler_assume[0].json

  tags = merge(local.cost_tags, { Name = "${var.project_name}-scheduler-role" })
}

resource "aws_iam_role_policy" "lab_scheduler_ec2" {
  count = var.enable_instance_schedule ? 1 : 0

  name = "${var.project_name}-scheduler-ec2"
  role = aws_iam_role.lab_scheduler[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:StopInstances",
          "ec2:StartInstances",
        ]
        Resource = aws_instance.lab.arn
      },
    ]
  })
}

resource "aws_scheduler_schedule" "lab_stop" {
  count = var.enable_instance_schedule ? 1 : 0

  name       = "${var.project_name}-stop-weekdays"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression          = var.instance_stop_schedule
  schedule_expression_timezone = var.instance_schedule_timezone

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"
    role_arn = aws_iam_role.lab_scheduler[0].arn
    input = jsonencode({
      InstanceIds = [aws_instance.lab.id]
    })
  }
}

resource "aws_scheduler_schedule" "lab_start" {
  count = var.enable_instance_schedule ? 1 : 0

  name       = "${var.project_name}-start-weekdays"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression          = var.instance_start_schedule
  schedule_expression_timezone = var.instance_schedule_timezone

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ec2:startInstances"
    role_arn = aws_iam_role.lab_scheduler[0].arn
    input = jsonencode({
      InstanceIds = [aws_instance.lab.id]
    })
  }
}
