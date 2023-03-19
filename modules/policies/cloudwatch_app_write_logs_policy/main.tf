resource "aws_iam_policy" "cloudwatch_app_write_logs_policy" {
  name = "cloudwatch-app-write-logs-policy"
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

resource "aws_iam_role_policy_attachment" "cloudwatch_app_write_logs_policy_attach_to_role" {
  policy_arn = aws_iam_policy.cloudwatch_app_write_logs_policy.arn
  role       = var.role_name
}
