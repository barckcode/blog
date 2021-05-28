#
# Workers
##
# Worker_1
resource "aws_instance" "worker01" {
  ami           = local.default_ami
  instance_type = local.default_instance_type
  subnet_id   = aws_subnet.main_subnet_01.id
  private_ip = "10.0.1.110"
  key_name = "ssh_key"

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name     = "worker01"
    Creation = "terraform"
  }
}

# Elastic IP
resource "aws_eip" "worker01_public_ip" {
  vpc = true

  instance                  = aws_instance.worker01.id
  associate_with_private_ip = "10.0.1.110"
  depends_on                = [aws_internet_gateway.main_internet_gw]

  tags = {
    Name     = "worker01_public_ip"
		Creation = "terraform"
  }
}

# Attached Segurity Groups
resource "aws_network_interface_sg_attachment" "worker01_sg_attachment" {
  security_group_id    = aws_security_group.web_sg.id
  network_interface_id = aws_instance.worker01.primary_network_interface_id
}
