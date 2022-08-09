resource "aws_security_group" "alb" {
  name = "${var.name}: ALB Security Group"

  ingress {
    from_port   = var.targets["http"].port
    to_port     = var.targets["http"].port
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "alb" {
  name                       = var.name
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb.id]
  enable_deletion_protection = false
  subnets                    = [for subnet in aws_default_subnet.vpc : subnet.id]
}

resource "aws_lb_listener" "alb" {
  for_each          = var.targets
  load_balancer_arn = aws_lb.alb.arn
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    target_group_arn = aws_lb_target_group.alb[each.key].arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "alb" {
  for_each = var.targets
  name     = "${var.name}-${each.value.protocol}-${each.value.port}"
  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = aws_default_vpc.vpc.id
  health_check {
    interval            = 6
    port                = "traffic-port"
    protocol            = each.value.protocol
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200,301,302"
  }
}
