#
# Web instances
##
# sauron
resource "aws_instance" "sauron" {
  ami           = local.default_ami
  instance_type = local.default_instance_type
  subnet_id     = aws_subnet.main_subnet_01.id
  private_ip    = "10.0.1.10"
  key_name      = "ssh_key"

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name     = "sauron"
		Creation = "terraform"
  }
}


# Elastic IP
resource "aws_eip" "sauron_public_ip" {
  vpc = true

  instance                  = aws_instance.sauron.id
  associate_with_private_ip = "10.0.1.10"
  depends_on                = [aws_internet_gateway.main_internet_gw]

  tags = {
    Name     = "sauron_public_ip"
		Creation = "terraform"
  }
}


# Attached Segurity Groups
resource "aws_network_interface_sg_attachment" "sauron_sg_attachment" {
  security_group_id    = aws_security_group.sauron_sg.id
  network_interface_id = aws_instance.sauron.primary_network_interface_id
}
