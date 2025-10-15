variable "instance_type" {}
variable "subnet_id" {}
variable "name" {}
variable "vpc_id" {}
variable "allow_sg_cidr" {
  type = "string"
}
variable "allow_port" {}
variable "env" {}