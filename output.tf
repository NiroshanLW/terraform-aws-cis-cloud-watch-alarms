output "alarm_arn" {
  value = aws_cloudwatch_metric_alarm.cis_metric_alarm[*].arn
}