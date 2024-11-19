resource "aws_lb" "ecommerce_lb" {
  name               = "ecommerce-lb"
  internal           = false #publicly accessible to internet
  load_balancer_type = "application" #best for HTTP/HTTPS traffic
  security_groups    = [var.frontend_sg_id]
  subnets            = [var.public_subnet_1a_id, var.public_subnet_1b_id]
  enable_deletion_protection = false

  tags = {
    Name = "ecommerce_lb"
  }
}

resource "aws_lb_listener" "ecommerce_listener" {
  load_balancer_arn = aws_lb.ecommerce_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_target.arn
  }
}

resource "aws_lb_target_group" "frontend_target" {
  name        = "frontend-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  health_check {
    path     = "/"
    port     = "3000"
    protocol = "HTTP"
  }
}

resource "aws_lb_target_group_attachment" "frontend_az1" {
  target_group_arn = aws_lb_target_group.frontend_target.arn
  target_id        = var.ecommerce_app_az1_id
  port             = 3000
}

resource "aws_lb_target_group_attachment" "frontend_az2" {
  target_group_arn = aws_lb_target_group.frontend_target.arn
  target_id        = var.ecommerce_app_az2_id
  port             = 3000
}
