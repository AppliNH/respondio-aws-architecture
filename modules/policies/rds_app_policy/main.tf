resource "aws_iam_policy" "rds_app_policy" {
  name = "rds-${var.db_name}-app-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "rds-db:connect",
          "rds-data:ExecuteStatement",
          "rds-data:BatchExecuteStatement",
          "rds-data:BeginTransaction",
          "rds-data:CommitTransaction",
          "rds-data:RollbackTransaction"
        ],
        Resource = var.target_resources_policy
        Condition = {
          StringEquals = {
            "rds:DatabaseName" = var.db_name
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_app_policy_attach_to_role" {
  policy_arn = aws_iam_policy.rds_app_policy.arn
  role       = var.role_name
}
