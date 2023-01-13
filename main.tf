data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet_ids" "subnet_ids" {
  vpc_id = data.aws_vpc.default_vpc.id
}

resource "aws_dynamodb_table" "requests" {
  name         = "requests"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "Id"
    type = "S"
  }

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  hash_key         = "Id"
}

module "stream-reader" {
  source                                = "./dynamodb-history-recorder"
  subnet_ids                            = data.aws_subnet_ids.subnet_ids.ids
  vpc_id                                = data.aws_vpc.default_vpc.id
  dynamodb_table_name                   = aws_dynamodb_table.requests.name
  dynamodb_partition_key_attribute_name = "Id"
  depends_on = [aws_dynamodb_table.requests]
}