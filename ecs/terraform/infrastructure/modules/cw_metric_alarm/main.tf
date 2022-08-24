locals {
  alarm_name          = "p-${var.alarm_priority}_s-${var.service}_e-${var.stage}_${var.alarm_name}"
  comparison_operator = var.comparison_operator
  namespace           = (var.namespace == "") ? "${var.service}-${var.stage}" : var.namespace
  metric_name         = var.metric_name
  dimensions          = var.dimensions
  alarm_description   = var.alarm_description
  alarm_actions       = var.alarm_actions
  ok_actions          = var.ok_actions
  evaluation_periods  = var.evaluation_periods
  datapoints_to_alarm = var.datapoints_to_alarm
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold
  treat_missing_data  = var.treat_missing_data
  tags = merge({
    Terraform     = true
    Stage         = var.stage
    Name          = var.alarm_name
    AlarmPriority = var.alarm_priority
    Service       = var.service
    Type          = "cortexCustomAlarm"
    Mute          = var.mute
  }, var.tags)
}

resource "aws_cloudwatch_metric_alarm" "cw_global_alarm" {
  alarm_name          = local.alarm_name
  comparison_operator = local.comparison_operator
  namespace           = local.namespace
  metric_name         = local.metric_name
  dimensions          = local.dimensions
  alarm_description   = local.alarm_description
  alarm_actions       = local.alarm_actions
  ok_actions          = local.ok_actions
  evaluation_periods  = local.evaluation_periods
  datapoints_to_alarm = local.datapoints_to_alarm
  period              = local.period
  statistic           = local.statistic
  threshold           = local.threshold
  treat_missing_data  = local.treat_missing_data
  tags                = local.tags
}
