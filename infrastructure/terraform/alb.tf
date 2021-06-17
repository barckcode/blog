# ALB Public
resource "aws_lb" "alb_public" {
  name               = "alb-public"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_public_sg.id]

	subnet_mapping {
		subnet_id	= aws_subnet.main_subnet_01.id
	}

	subnet_mapping {
		subnet_id	= aws_subnet.main_subnet_02.id
	}

  enable_deletion_protection = false

  tags = {
    Name     = "alb_public"
		Creation = "terraform"
  }
}


# Listeners
resource "aws_lb_listener" "sauron_http" {
  load_balancer_arn = aws_lb.alb_public.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "sauron_https" {
  load_balancer_arn = aws_lb.alb_public.arn
  port              = "443"
  protocol          = "HTTPS"
	ssl_policy        = "ELBSecurityPolicy-2016-08"
	certificate_arn   = "arn:aws:acm:eu-west-1:243849010608:certificate/3347b8c0-a50b-453c-ae02-d43fb1ea091a"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sauron_tg.arn
  }
}


# Target Groups
resource "aws_lb_target_group" "sauron_tg" {
  name     		= "sauron-tg"
  port     		= 80
  protocol 		= "HTTP"
	protocol_version = "HTTP1"
  vpc_id   		= aws_vpc.main.id

	tags = {
    Name     = "sauron_tg"
		Creation = "terraform"
	}
}

resource "aws_lb_target_group_attachment" "http" {
  target_group_arn = aws_lb_target_group.sauron_tg.arn
  target_id        = aws_instance.sauron.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "jenkins" {
  target_group_arn = aws_lb_target_group.sauron_tg.arn
  target_id        = aws_instance.sauron.id
  port             = 8080
}
