variable account_name {
  type        = string 
  description = "Name of the account"
}

variable resource_type {
  type        = list(string) 
  description = "Name of the resource type relevent to the alarm"
}

variable metric_filter {
  type        = list(string) 
  description = "Name of the resource type relevent to the alarm"
}