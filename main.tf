# Define Provider onfig

provider "aws" {
  profile = "default"
  region  = "ap-southeast-1"
}

# Configure SNS Topic
resource "aws_sns_topic" "cis_cloudwatch_alarm" {
  name         = "cis-cloudwatch-alarm"
  display_name = "CIS-Cloudwatch-Alarm"
}

# Configure SNS Topic Subscription

resource "aws_sns_topic_subscription" "cis_cloudwatch_alarm_target" {
  topic_arn = aws_sns_topic.cis_cloudwatch_alarm.arn
  protocol  = "email"
  endpoint  = "AWS-CloudWatch-XXXXX@XXXXX.com"
}

# Configure a log metric filter 

resource "aws_cloudwatch_log_metric_filter" "cis_metric_filter" {
  count          = length(var.resource_type) 
  name           = "${var.account_name}-cis-metric-filter-${var.resource_type[count.index]}-changes"
  pattern        = var.metric_filter[count.index]
  log_group_name = "aws-controltower/CloudTrailLogs"

  metric_transformation {
    name      = "${var.account_name}-cis-metric-${var.resource_type[count.index]}-changes"
    namespace = "cis-log-metrics"
    value     = "1"
  }
}

# Configure a metric alarm

resource "aws_cloudwatch_metric_alarm" "cis_metric_alarm" {
  count                     = length(var.resource_type) 
  alarm_name                = "cis-metric-${var.resource_type[count.index]}-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               =  aws_cloudwatch_log_metric_filter.cis_metric_filter[count.index].metric_transformation[0].name
  namespace                 =  aws_cloudwatch_log_metric_filter.cis_metric_filter[count.index].metric_transformation[0].namespace   
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "This metric monitors ${var.resource_type[count.index]} changes"
  insufficient_data_actions = []

  actions_enabled     = "true"
  alarm_actions       = [aws_sns_topic.cis_cloudwatch_alarm.arn]
}

