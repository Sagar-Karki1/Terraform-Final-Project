# Target Group Configuration
resource "aws_lb_target_group" "finalProject_tg" {
  name     = "finalproject-tg"
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

resource "aws_lb_target_group_attachment" "webserver1" {
  count = length(var.instance_ids)
  target_group_arn = aws_lb_target_group.finalProject_tg.arn
  target_id        = var.instance_ids[count.index]
  port             = 80
  
}


resource "aws_alb" "finalProject_alb" {
  name            = "finalproject-alb"
  internal        = false
  load_balancer_type = "application"
  ip_address_type = "ipv4"
  security_groups = [var.alb_sg_id]
  subnets         = var.subnet_ids

  tags = {
    Environment = "${var.env}"
    Name        = "finalproject-alb"
  }
  
}


# ─── ALB LISTENER ───────────────────────────────────────────
# A Listener watches for incoming traffic on a specific port
# Without this, the ALB exists but ignores all incoming requests
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_alb.finalProject_alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    # Forward = send the request to a target group
    # The target group then picks a healthy webserver to handle it
    type = "forward"

    # Which target group to forward traffic to
    # The target group contains our registered webservers
    target_group_arn = aws_lb_target_group.finalProject_tg.arn
  }
}
