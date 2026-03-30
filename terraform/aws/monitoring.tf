resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.project_name}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "EC2 CPU utilization exceeded 80% for 15 minutes – consider upsizing the instance type"
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.lab.id
  }

  tags = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.project_name}-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 12
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 10
  alarm_description   = "EC2 CPU utilization below 10% for 1 hour – consider downsizing the instance type to save costs"
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.lab.id
  }

  tags = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "disk_read_high" {
  alarm_name          = "${var.project_name}-disk-read-ops-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "DiskReadOps"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Sum"
  threshold           = 10000
  alarm_description   = "High disk read operations – review EBS volume type and IOPS configuration"
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.lab.id
  }

  tags = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "network_out_high" {
  alarm_name          = "${var.project_name}-network-out-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "NetworkOut"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Sum"
  threshold           = 500000000
  alarm_description   = "High outbound network traffic (>500MB/5min) – review for anomalous egress"
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.lab.id
  }

  tags = local.common_tags
}
