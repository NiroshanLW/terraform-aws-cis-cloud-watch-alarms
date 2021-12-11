variable account_name {
  type        = string 
  description = "Name of the aaccount"
}

variable resource_type {
  type        = list(string) 
  description = "Name of the resource type elevent to the alarm"
}

variable metric_filter {
  type        = list(string) 
  description = "Syntax of metric filter"
}