resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main",
		Creation = "terraform",
  }
}

resource "aws_subnet" "main_subnet_01" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "main_subnet_01",
    Creation = "terraform",
  }
}