
resource "aws_security_group" "main" {
  name          = "${var.name}-sg"
  description   = "${var.name}-sg"
  vpc_id        =  var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = "0.0.0.0/0"
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
  cidr_blocks       = var.allow_sg_cidr
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

resource "aws_instance" "main" {
  ami                      = data.aws_ami.rhel9.image_id
  instance_type            = var.instance_type
  subnet_id                = var.subnet_id[0]
  vpc_security_group_ids   = [aws_security_group.main.id]

  user_data = base64encode(templatefile("${path.module}/userdata.sh",{
      env = var.env
      role_name = var.name
    }))

  tags = {
    name = "${var.name}-${var.env}"
  }
}
