# Optional: stop/start the lab instance on a schedule to cut compute when the VM is not needed.

data "aws_partition" "current" {}

resource "aws_iam_role" "lab_ec2_schedule" {
  count = var.enable_instance_schedule ? 1 : 0
  name  = "${var.project_name}-scheduler-ec2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "scheduler.${data.aws_partition.current.dns_suffix}"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "${var.project_name}-scheduler-ec2-role"
  }
}

resource "aws_iam_role_policy" "lab_ec2_schedule" {
  count = var.enable_instance_schedule ? 1 : 0
  name  = "${var.project_name}-scheduler-ec2-policy"
  role  = aws_iam_role.lab_ec2_schedule[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "StartStopLabInstance"
      Effect = "Allow"
      Action = [
        "ec2:StartInstances",
        "ec2:StopInstances",
      ]
      Resource = aws_instance.lab.arn
    }]
  })
}

resource "aws_scheduler_schedule" "lab_stop" {
  count = var.enable_instance_schedule ? 1 : 0

  name       = "${var.project_name}-ec2-stop"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression          = var.instance_stop_schedule
  schedule_expression_timezone = var.instance_schedule_timezone

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"
    role_arn = aws_iam_role.lab_ec2_schedule[0].arn

    input = jsonencode({
      InstanceIds = [aws_instance.lab.id]
    })
  }
}

resource "aws_scheduler_schedule" "lab_start" {
  count = var.enable_instance_schedule ? 1 : 0

  name       = "${var.project_name}-ec2-start"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression          = var.instance_start_schedule
  schedule_expression_timezone = var.instance_schedule_timezone

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ec2:startInstances"
    role_arn = aws_iam_role.lab_ec2_schedule[0].arn

    input = jsonencode({
      InstanceIds = [aws_instance.lab.id]
    })
  }
}
