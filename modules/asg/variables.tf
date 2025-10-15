variable "name" {
  type = "string"
}
variable "vpc_id" {}
variable "allow_ports" {}
variable "allow_sg_cidr" {
  type = "string"
}
variable "capacity" {}
variable "instance_type" {}
variable "env" {}
variable "subnet_id" {}
variable "bastion_node" {}