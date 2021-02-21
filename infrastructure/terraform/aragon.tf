#
# Aragon
##
# SSH RSA KEY
resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDqrgCrhQIjroRFQguUGhKTKQTWLZlhM+pj4r/9RMSJrxX+1IHcGk2+lAcKh32EWcsSGH3CR3yEUHDgsbLSOQO5zO9/5UEqkJ80usWrjTwf8ix3egi+e5uGcVO7PUaXBqui4sp84aK5B6NoyHf2sAMwFrxF8q8tQVI+g13cqJ1RlHQjnLcq1l/FdFLcHfBcfH/yJTFqwpmyslRhmD1hk8KR5uhphUvTyEJRxEByH0x0eev63dsJh73UFrfu3WnRuBRI7m+lh3amTvq+BRG+f9JcEPM9uGvtsEi8E6WXWrqF9zRuS74ih79J6Fl40As1bSLUHdoi4tByzDo2PuGE/vwijo+wUBYnF2IlTz8FGy6R5V/PC1EokaUyYeMhn714aSBhHTV8wreAW5vT+Aan/vDMsxuUIhGDu6VLeIYgctzhd61n1UXXd52/5pgJW1BEHLXZfwZBQKpP/EoenLBmh3fbzHFzpq+1AMcQQzmbgr0cz9urvSy7syXp9PAnhjwpwus= barckcode@gmail.com"
}


# Instance
resource "aws_instance" "aragon" {
  ami           = local.aragon_ami
  instance_type = local.aragon_instance_type
  subnet_id   = aws_subnet.main_subnet_01.id
  associate_public_ip_address  = false
  private_ip = "10.0.1.100"
  key_name = "ssh_key"

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = "aragon",
		Creation = "terraform",
  }
}


# Elastic IP
resource "aws_eip" "aragon_public_ip" {
  vpc = true

  instance                  = aws_instance.aragon.id
  associate_with_private_ip = "10.0.1.100"
  depends_on                = [aws_internet_gateway.main_internet_gw]

  tags = {
    Name = "aragon_public_ip",
		Creation = "terraform",
  }
}


# Segurity Groups
resource "aws_security_group" "aragon_sg" {
  name        = "aragon_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from all"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_aragon_sg",
    Creation = "terraform",
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.aragon_sg.id
  network_interface_id = aws_instance.aragon.primary_network_interface_id
}
