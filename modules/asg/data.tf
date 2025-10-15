data "aws_ami" "rhel9" {
  most_recent = true
  owners      = ["309956199498"] # Red Hat official AWS account ID

  filter {
    name   = "name"
    values = ["RHEL-9*"]   # broader match to catch variations
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

