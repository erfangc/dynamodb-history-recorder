resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.stream_reader.function_name}"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_lambda_function" "stream_reader" {

  function_name    = "${var.dynamodb_table_name}-dynamodb-history-recorder"
  role             = aws_iam_role.stream_reader_lambda_role.arn
  filename         = "lambda_code.zip"
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  handler          = "lambda_function.lambda_handler"

  environment {
    variables = {
      "DYNAMODB_PARTITION_KEY_ATTRIBUTE_NAME" = data.aws_dynamodb_table.dynamodb_table.hash_key
      "DYNAMODB_SORT_KEY_ATTRIBUTE_NAME"      = data.aws_dynamodb_table.dynamodb_table.range_key
      "DYNAMODB_HISTORY_TABLE_NAME"           = aws_dynamodb_table.history_table.name
      "DYNAMODB_USER_ID_ATTRIBUTE_NAME"       = var.dynamodb_user_id_attribute_name
    }
  }

  vpc_config {
    security_group_ids = [aws_security_group.sg.id]
    subnet_ids         = var.subnet_ids
  }

  runtime = "python3.9"
}

resource "aws_lambda_event_source_mapping" "stream_reader_lambda_event_source_mapping" {
  function_name     = aws_lambda_function.stream_reader.arn
  starting_position = "LATEST"
  event_source_arn  = data.aws_dynamodb_table.dynamodb_table.stream_arn
}


data "archive_file" "python_lambda_package" {
  output_path = "lambda_code.zip"
  type        = "zip"
  source_file = "${path.module}/code/lambda_function.py"
}