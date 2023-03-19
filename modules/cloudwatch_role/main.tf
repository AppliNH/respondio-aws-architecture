resource "aws_iam_role" "main_role" {
  name = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = var.target_service
        }
      }
    ]
  })
}

module "cloudwatch_write_logs_policy" {
  source                 = "../cloudwatch_write_logs_policy"
  target_resource_policy = var.target_service
}

resource "aws_iam_role_policy_attachment" "cloudwatch_ec2_role_policy" {
  policy_arn = module.cloudwatch_write_logs_policy.details.arn
  role       = aws_iam_role.main_role.name
}
