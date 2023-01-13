variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "dynamodb_table_name" {
  type = string
}

variable "dynamodb_user_id_attribute_name" {
  type    = string
  default = null
}

variable "history_table_billing_mode" {
  type    = string
  default = "PAY_PER_REQUEST"
}

variable "history_table_read_capacity" {
  type    = number
  default = null
}

variable "history_table_write_capacity" {
  type    = number
  default = null
}

variable "history_table_tags" {
  type    = map(string)
  default = null
}
