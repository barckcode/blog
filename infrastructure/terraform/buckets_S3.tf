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
