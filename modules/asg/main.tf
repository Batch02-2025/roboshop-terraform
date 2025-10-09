
resource "aws_security_group" "main" {
  name          = "${var.name}-sg"
  description   = "${var.name}-sg"
  vpc_id        =  var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = var.bastion_node
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "Allow ssh inbound traffic"
}

resource "aws_vpc_security_group_ingress_rule" "allow_port" {
  for_each          = var.allow_ports
  security_group_id = aws_security_group.main.id
  from_port         = each.value
  to_port           = each.value
  cidr_ipv4         = var.allow_sg_cidr
  ip_protocol       = "TCP"
  description       = "${var.name}-allow-port"
}

resource "aws_vpc_security_group_egress_rule" "allow-egress" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # Allows all protocols
  from_port         = 0    # Allows all ports
  to_port           = 0    # Allows all ports
}

resource "aws_launch_template" "main" {
  name_prefix   = "${var.name}-${var.env}-lt"
  image_id      = data.aws_ami.rhel9.image_id
  instance_type = var.instance_type

  user_data = base64encode(templatefile("${path.module}/userdata.sh",{
    env = var.env
    role_name = var.name
  }))

  tags = {
    name = "${var.name}-${var.env}"
  }

}

resource "aws_autoscaling_group" "main" {
  name                = "${var.name}-${var.env}-asg"
  desired_capacity    = var.capacity["desired"]
  max_size            = var.capacity["max"]
  min_size            = var.capacity["min"]
  vpc_zone_identifier = var.subnet_id


  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "${var.name}-${var.env}"
  }
}

resource "aws_lb_target_group" "main" {
  name     = "${var.name}-${var.env}-tg"
  port     = var.allow_ports
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    path                = "/health"
    interval            = 5
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}