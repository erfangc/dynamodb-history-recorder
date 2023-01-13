output "history_table_name" {
  value = aws_dynamodb_table.history_table.name
}

output "lambda_function_name" {
  value = aws_lambda_function.history_recorder.function_name
}

output "lambda_security_group_id" {
  value = aws_security_group.sg.id
}

output "lambda_security_group_name" {
  value = aws_security_group.sg.name
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.function_log_group.name
}