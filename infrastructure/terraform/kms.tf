resource "aws_kms_key" "terraform_key" {
  description             = "Key for encript terraform state"
  deletion_window_in_days = 10
}
