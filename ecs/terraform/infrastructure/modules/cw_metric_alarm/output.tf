output "cw_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.cw_global_alarm.arn
}

output "cw_alarm_name" {
  value = aws_cloudwatch_metric_alarm.cw_global_alarm.alarm_name
}
