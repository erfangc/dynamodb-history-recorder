data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet_ids" "subnet_ids" {
  vpc_id = data.aws_vpc.default_vpc.id
}

resource "aws_dynamodb_table" "orders" {
  name         = "orders"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "Id"
    type = "S"
  }

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  hash_key         = "Id"
}

module "orders-recorder" {
  source                          = "../"
  subnet_ids                      = data.aws_subnet_ids.subnet_ids.ids
  vpc_id                          = data.aws_vpc.default_vpc.id
  dynamodb_table_name             = aws_dynamodb_table.orders.name
  dynamodb_user_id_attribute_name = "updatedBy"
  depends_on                      = [aws_dynamodb_table.orders]
}

resource "aws_dynamodb_table" "trades" {
  name         = "orders"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "AccountId"
    type = "S"
  }

  attribute {
    name = "Ticker"
    type = "S"
  }

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  hash_key         = "Ticker"
  range_key        = "AccountId"
}

module "trades-recorder" {
  source                          = "../"
  subnet_ids                      = data.aws_subnet_ids.subnet_ids.ids
  vpc_id                          = data.aws_vpc.default_vpc.id
  dynamodb_table_name             = aws_dynamodb_table.trades.name
  dynamodb_user_id_attribute_name = "updatedBy"
  depends_on                      = [aws_dynamodb_table.trades]
}