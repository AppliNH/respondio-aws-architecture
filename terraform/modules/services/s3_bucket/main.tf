resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "${var.context_name}-bucket-"

  tags = {
    Name  = "${var.context_name}-bucket"
    APP   = var.context_name
    STAGE = var.stage

  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

module "bucket_policy" {
  source = "../../policies/s3_bucket_app_policy"
  target_resources_policy = [
    "${aws_s3_bucket.bucket.arn}",
    "${aws_s3_bucket.bucket.arn}/*"
  ]
  role_name = var.app_role_name
}
