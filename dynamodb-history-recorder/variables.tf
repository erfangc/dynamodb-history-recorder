variable "subnet_ids" {
  type        = list(string)
  description = "Subnet(s) in which to run the Lambdas"
}

variable "vpc_id" {
  type        = string
  description = "The VPC in which to run the Lambda"
}

variable "dynamodb_table_name" {
  type = string
}

variable "dynamodb_partition_key_attribute_name" {
  type = string
}

variable "dynamodb_sort_key_attribute_name" {
  type = string
  default = null
}

variable "history_table_billing_mode" {
  type = string
  default = "PAY_PER_REQUEST"
}

variable "history_table_read_capacity" {
  type = number
  default = null
}

variable "history_table_write_capacity" {
  type = number
  default = null
}

variable "history_table_tags" {
  type = map(string)
  default = null
}