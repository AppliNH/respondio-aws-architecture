resource "aws_iam_policy" "cloudwatch_write_logs_policy" {
  name = "cloudwatch_write_logs_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = var.target_resources_policy
      }
    ]
  })
}

