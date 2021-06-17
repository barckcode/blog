# Bucket for Backend // Terraform Remote State
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state.helmcode.com"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.terraform_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    Name        = "terraform_state"
    Creation    = "terraform"
  }
}

resource "aws_s3_bucket" "static_files" {
  bucket = "static.helmcode.com"
  acl    = "public-read"

  tags = {
    Name        = "static_files"
    Creation    = "terraform"
  }
}

resource "aws_s3_bucket" "source_code" {
  bucket = "source.helmcode.com"
  acl    = "private"

  tags = {
    Name        = "source_code"
    Creation    = "terraform"
  }
}
