data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/files"
  output_path = "${path.root}/tmp/deployment.zip"
}

resource "random_id" "bucket_suffix" {
  byte_length = 8
}

resource "aws_s3_bucket" "deployment_bucket" {
  bucket = "${var.slug}-deployment-bucket-${random_id.bucket_suffix.hex}"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.deployment_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.deployment_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "function_zip" {
  bucket = aws_s3_bucket.deployment_bucket.id
  key    = "deployment.zip"
  source = data.archive_file.function_zip.output_path

  # Ensure the object is updated when the ZIP contents change
  etag = data.archive_file.function_zip.output_md5

  depends_on = [data.archive_file.function_zip]
}
