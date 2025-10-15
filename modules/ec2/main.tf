# Security Group creation
resource "aws_security_group" "main" {
  name        = "${var.name}-sg"
  description = "${var.name}-sg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-sg"
  }
}

# Ingress Rule 1
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "Allow SSH Inbound Traffic"
}

# Ingress Rule 2
resource "aws_vpc_security_group_ingress_rule" "allow_port" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = var.allow_sg_cidr
  from_port         = var.allow_port
  to_port           = var.allow_port
  ip_protocol       = "tcp"
  description       = "Allow-${var.name}-${var.allow_port}port"
}

# Egress Rule
resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
  from_port         = 0 # allow all ports
  to_port           = 0 # allow all ports
}

# Instance Creation
resource "aws_instance" "main" {
  ami                     = data.aws_ami.rhel9.image_id
  instance_type           = var.instance_type
  subnet_id               = var.subnet_id[0]
  vpc_security_group_ids  = [aws_security_group.main.id]

  user_data = base64encode(file("${path.module}/userdata.sh")

  tags = {
    Name = "${var.name}-${var.env}"
  }
}