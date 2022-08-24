locals {
  alarm_name        = "p-${var.alarm_priority}_s-${var.service}_e-${var.stage}_${var.alarm_name}"
  alarm_description = var.alarm_description
  alarm_rule        = var.alarm_rule


  tags = merge({
    Terraform     = true
    Stage         = var.stage
    Name          = var.alarm_name
    AlarmPriority = var.alarm_priority
    Service       = var.service
    Type          = "cortexCustomAlarm"
  }, var.tags)
}

resource "aws_cloudwatch_composite_alarm" "cw_global_composite_alarm" {
  alarm_name        = local.alarm_name
  alarm_description = local.alarm_description
  alarm_rule        = local.alarm_rule
  tags              = local.tags
}