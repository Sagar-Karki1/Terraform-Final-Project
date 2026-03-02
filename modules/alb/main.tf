# Target Group Configuration
resource "aws_lb_target_group" "finalProject_target_group" {
  name     = "finalproject-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


resource "aws_alb" "finalProject_alb" {
  name            = "finalproject-alb"
  internal        = false
  security_groups = [aws_security_group.alb_sg.id]
  subnets         = var.subnet_ids

  tags = {
    Environment = "production"
    Name        = "finalproject-alb"
  }
  
}