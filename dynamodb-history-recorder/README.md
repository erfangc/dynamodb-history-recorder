# Terraform Module dynamodb-history-recorder

This Terraform Module takes an existing DynamoDB table (with DynamoDB Stream enabled) and write all
changes to items on the table to another table (aka the `history` table) via a Lambda

The hash and range keys of the original table are concatenated to form `originalItemID` which is the hash key of
the `history` table

## How to Use

Create a DynamoDB table

```hcl
resource "aws_dynamodb_table" "requests" {
  name         = "requests"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "Id"
    type = "S"
  }
  
  # it is critical DynamoDB Stream is enabled, and view type contains old and new images
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  hash_key         = "Id"
}
```

Instantiate this Module

```hcl
module "stream-reader" {
  source                                = "./dynamodb-history-recorder"
  
  # it's up to you how you obtain the subnet_ids and vpc_id
  subnet_ids                            = data.aws_subnet_ids.subnet_ids.ids
  vpc_id                                = data.aws_vpc.default_vpc.id
  
  dynamodb_table_name                   = aws_dynamodb_table.requests.name
  dynamodb_partition_key_attribute_name = "Id"
  
  # you might need this if the DynamoDB table being recorded does not already exist
  depends_on                            = [aws_dynamodb_table.requests]
}
```

## Argument Reference

`subnet_ids` -


`vpc_id` -


`dynamodb_table_name` -


`dynamodb_partition_key_attribute_name` -


`dynamodb_sort_key_attribute_name` -


`dynamodb_user_id_attribute_name` -


`history_table_billing_mode` -


`history_table_read_capacity` -


`history_table_write_capacity` -


`history_table_tags` -


## Attributes Reference

`history_table_name` - 


`lambda_function_name` - 


`lambda_security_group_id` - 


`lambda_security_group_name` - 


`cloudwatch_log_group_name` - 

