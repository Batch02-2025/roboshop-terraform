resource "aws_security_group" "lb-sg" {
  name          = "${var.name}-lb-sg"
  description   = "${var.name}-lb-sg"
  vpc_id        =  var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.lb-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "Allow Http inbound traffic"
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.lb-sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "TCP"
  description       = "${var.name}-allow-https"
}

resource "aws_vpc_security_group_egress_rule" "allow-egress" {
  security_group_id = aws_security_group.lb-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # Allows all protocols
  from_port         = 0    # Allows all ports
  to_port           = 0    # Allows all ports
}

# Load Balancer creation
resource "aws_lb" "main" {
  name               = "${var.name}-${var.env}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = var.subnet_id

  tags = {
    Environment = "${var.name}-${var.env}-alb"
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.acm_https_arn

  default_action {
    type = "fixed-response"
  }

    fixed_response {
      content_type = "text/plain"
      message_body = "Configuration Error/ Input is not as Expection"
      status_code  = "500"
  }

}

resource "aws_lb_listener" "public-http" {
  count             = var.internal ? 0 : 1
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301" # Permanent redirect
    }
  }
}