project = "blog"

app "" {
  build {
    use "aws-ami" {
			region = "eu-west-1"
			name 	 = "webas-ami-v1"
		}
  }

  deploy {
    use "aws-ec2" {
			count  					= 1
			instance_type 	= "t3.micro"
      region 					= "eu-west-1"
			service_port		= "80"
			key							= "ssh_key"
			security_groups = [web_sg]
			subnet					= "main_subnet_01"
    }
  }

  release {
    use "aws-alb" {
    }
  }
}
