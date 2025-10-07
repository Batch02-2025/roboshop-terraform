module "vpc" {
  source = "./modules/vpc"

  cidr                  = var.vpc["cidr"]
  env                   = var.env
  public_subnets        = var.vpc["public_subnets"]
  web_subnets           = var.vpc["web_subnets"]
  app_subnets           = var.vpc["app_subnets"]
  db_subnets            = var.vpc["db_subnets"]
  availability_zone     = var.vpc["availability_zone"]
  default_vpc_id        = var.vpc["default_vpc_id"]
  default_vpc_cidr      = var.vpc["default_vpc_cidr"]
  default_rt_id         = var.vpc["default_rt_id"]

}

module "apps" {
  source = "./modules/ec2"

  for_each          = var.apps
  name              = each.key
  instance_type     = each.value["instance_type"]
  allow_ports       = each.value["allow_ports"]
  allow_sg_cidr     = each.value["allow_sg_cidr"]
  subnet_id         = module.vpc.subnets[each.value["subnet_ref"]]
  vpc_id            = module.vpc.vpc_id
  env               = var.env
  capacity          = each.value["capacity"]
}

module "db" {
  source = "./modules/ec2"

  for_each          = var.db
  name              = each.key
  instance_type     = each.value["instance_type"]
  allow_ports       = each.value["allow_ports"]
  allow_sg_cidr     = each.value["allow_sg_cidr"]
  subnet_id         = module.vpc.subnets[each.value["subnet_ref"]]
  vpc_id            = module.vpc.vpc_id
  env               = var.env

}
