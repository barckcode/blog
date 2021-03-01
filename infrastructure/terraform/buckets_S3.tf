resource "aws_s3_bucket" "static_files" {
  bucket = "static.helmcode.com"
  acl    = "public-read"

  tags = {
    Name        = "static_files"
    Creation    = "terraform"
  }
}
