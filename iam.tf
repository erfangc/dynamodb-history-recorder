resource "aws_iam_role" "history_recorder_lambda_role" {
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "history_recorder_policy" {
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "logs:CreateLogGroup",
          "Resource" : "arn:aws:logs:us-east-1:422873008393:*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : [
            "arn:aws:logs:us-east-1:422873008393:log-group:/aws/lambda/*:*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "ec2:CreateNetworkInterface",
            "ec2:DeleteNetworkInterface",
            "ec2:DescribeNetworkInterfaces"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:PutItem",
            "dynamodb:GetShardIterator",
            "dynamodb:DescribeStream",
            "dynamodb:GetRecords"
          ],
          "Resource" : [
            "arn:aws:dynamodb:*:422873008393:table/${var.dynamodb_table_name}",
            "arn:aws:dynamodb:*:422873008393:table/${var.dynamodb_table_name}/stream/*"
          ]
        },
        {
          "Sid" : "VisualEditor1",
          "Effect" : "Allow",
          "Action" : "dynamodb:ListStreams",
          "Resource" : [
            "arn:aws:dynamodb:*:422873008393:table/${var.dynamodb_table_name}",
            "arn:aws:dynamodb:*:422873008393:table/${var.dynamodb_table_name}/stream/*"
          ]
        }
      ]
    }
  )
}


resource "aws_iam_role_policy_attachment" "stream_recorder_policy_attachment" {
  policy_arn = aws_iam_policy.history_recorder_policy.arn
  role       = aws_iam_role.history_recorder_lambda_role.name
}
