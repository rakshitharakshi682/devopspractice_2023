resource "aws_s3_bucket" "mybucket" {
  bucket = "s3-statebackend-01"
}

resource "aws_s3_bucket_versioning" "versioning_practices3" {
  bucket = aws_s3_bucket.mybucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "prctice" {
  bucket = aws_s3_bucket.mybucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
