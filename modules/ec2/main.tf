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
  for_each          = var.allow_sg_cidr
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = each.value
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

  user_data = <<-EOF
  #!/bin/bash

  # Update the System
  sudo dnf update -y
  sudo dnf upgrade -y

  # Set hostname
  sudo hostnamectl set-hostname "${var.name}" --static

  # Download the latest EPEL release RPM for RHEL 9
  sudo curl -O https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

  # Install it manually
  sudo rpm -ivh epel-release-latest-9.noarch.rpm

  # Clean and refresh DNF
  sudo dnf clean all
  sudo dnf makecache

  # Install Basic Utilities
  sudo dnf install -y vim wget git unzip net-tools bind-utils telnet traceroute nmap htop tree bash-completion iputils

  # Security & Networking Tools
  sudo dnf install -y tcpdump openssl openssh-clients

  # Reboot after setup
  sudo reboot
EOF

  tags = {
    Name = "${var.name}-${var.env}"
  }
}