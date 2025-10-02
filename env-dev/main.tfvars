env               =  "dev"
bastion_node      = "172.31.33.132/32"


vpc = {

  cidr                = "10.10.0.0/16"
  public_subnets      = ["10.10.0.0/24", "10.10.1.0/24"]
  web_subnets         = ["10.10.2.0/24", "10.10.3.0/24"]
  app_subnets         = ["10.10.4.0/24", "10.10.5.0/24"]
  db_subnets          = ["10.10.6.0/24", "10.10.7.0/24"]
  availbility_zone    = ["ap-south-1a, ap-south-1b"]
  default_vpc_id      = "vpc-034c7e7aaa56a2a77"
  default_vpc_cidr    = "172.31.0.0/16"
  default_rt_id       = "rtb-02fe9bf40d5757796"
}

apps = {

  frontend = {
    subnet_ref      = "web"
    instance_type   = "t3.small"
    allow_port      = 80
    allow_sg_cidr   = ["10.10.0.0/24", "10.10.1.0/24"]

  }

  catalouge = {
    subnet_ref      = "app"
    instance_type   = "t3.small"
    allow_port      = 8080
    allow_sg_cidr   = ["10.10.4.0/24", "10.10.5.0/24"]
  }

  user = {
    subnet_ref      = "app"
    instance_type   = "t3.small"
    allow_port      = 8080
    allow_sg_cidr   = ["10.10.4.0/24", "10.10.5.0/24"]
  }

  cart = {
    subnet_ref      = "app"
    instance_type   = "t3.small"
    allow_port      = 8080
    allow_sg_cidr   = ["10.10.4.0/24", "10.10.5.0/24"]
  }

  shipping = {
    subnet_ref      = "app"
    instance_type   = "t3.small"
    allow_port      = 8080
    allow_sg_cidr   = ["10.10.4.0/24", "10.10.5.0/24"]
  }

  payment = {
    subnet_ref      = "app"
    instance_type   = "t3.small"
    allow_port      = 8080
    allow_sg_cidr   = ["10.10.4.0/24", "10.10.5.0/24"]
  }
}

db ={
  mongo = {
    subnet_ref      = "db"
    instance_type   = "t3.small"
    allow_port      = 27017
    allow_sg_cidr   = ["10.10.4.0/24", "10.10.5.0/24"]
  }
  mysql = {
    subnet_ref      = "db"
    instance_type   = "t3.small"
    allow_port      = 3306
    allow_sg_cidr   = ["10.10.4.0/24", "10.10.5.0/24"]
  }
  rabbitmq = {
    subnet_ref      = "db"
    instance_type   = "t3.small"
    allow_port      = 5672
    allow_sg_cidr   = ["10.10.4.0/24", "10.10.5.0/24"]
  }
  redis = {
    subnet_ref      = "db"
    instance_type   = "t3.small"
    allow_port      = 6379
    allow_sg_cidr   = ["10.10.4.0/24", "10.10.5.0/24"]
  }
}
