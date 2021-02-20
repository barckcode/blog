#
# Aragon
##
# Network Interfaces
resource "aws_network_interface" "aragon_eth0" {
  subnet_id   = aws_subnet.main_subnet_01.id
  private_ips = ["10.0.1.100"]

  tags = {
    Name = "aragon_eth0",
    Creation = "terraform",
  }
}


# Instance
resource "aws_instance" "aragon" {
  ami           = local.aragon_ami
  instance_type = local.aragon_instance_type

	network_interface {
    network_interface_id = aws_network_interface.aragon_eth0.id
    device_index         = 0
  }

  tags = {
    Name = "aragon",
		Creation = "terraform",
  }
}


# Volumes
resource "aws_ebs_volume" "aragon_root" {
  availability_zone = "eu-west-1a"
  size              = 50

  tags = {
    Name = "aragon_root",
		Creation = "terraform",
  }
}

resource "aws_volume_attachment" "aragon_sdh" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.aragon_root.id
  instance_id = aws_instance.aragon.id
}
