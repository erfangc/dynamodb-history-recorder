data aws_dynamodb_table dynamodb_table {
  name = var.dynamodb_table_name
}

resource "aws_dynamodb_table" "history_table" {

  name      = "${var.dynamodb_table_name}_history"
  hash_key  = "originalItemID"
  range_key = "approximateTimestamp"
  
  attribute {
    name = "approximateTimestamp"
    type = "N"
  }

  attribute {
    name = "originalItemID"
    type = "S"
  }

  billing_mode   = var.history_table_billing_mode
  read_capacity  = var.history_table_read_capacity
  write_capacity = var.history_table_write_capacity

  tags = var.history_table_tags

}