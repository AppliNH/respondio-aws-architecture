resource "aws_iam_policy" "bucket_app_policy" {
  name = "bucket-app-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = var.target_resources_policy
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "bucket_app_policy_attach_to_role" {
  policy_arn = aws_iam_policy.bucket_app_policy.arn
  role       = var.role_name
}
