env           = "prod"
bastion_node  = "workstation ip"

vpc = {

  cidr                  = "192.168.0.0/16"
  public_subnets        = ["192.168.0.0/24", "192.168.1.0/24"]
  web_subnets           = ["192.168.2.0/24", "192.168.3.0/24"]
  app_subnets           = ["192.168.4.0/24", "192.168.5.0/24"]
  db_subnets            = ["192.168.6.0/24", "192.168.7.0/24"]
  availability_zone     = ["ap-south-1a", "ap-south-1b"]
  default_vpc_id        = "vpc-034c7e7aaa56a2a77"
  default_vpc_cidr      = "172.31.0.0/16"
  default_rt_id         = "rtb-02fe9bf40d5757796"

}

apps = {

  frontend = {
    instance_type = "t2.small"
    subnet_ref    = "web"
    allow_port    = 80
    allow_sg_cidr = ["192.168.0.0/24", "192.168.1.0/24"]
    capacity      = {
      desired     = 1
      max         = 1
      min         = 1
    }
  }

  catalogue = {
    instance_type = "t2.small"
    subnet_ref    = "app"
    allow_port    = 8080
    allow_sg_cidr = ["192.168.4.0/24", "192.168.5.0/24"]
    capacity      = {
      desired     = 1
      max         = 1
      min         = 1
    }
  }

  user = {
    instance_type = "t2.small"
    subnet_ref    = "app"
    allow_port    = 8080
    allow_sg_cidr = ["192.168.4.0/24", "192.168.5.0/24"]
    capacity      = {
      desired     = 1
      max         = 1
      min         = 1
    }
  }

  cart = {
    instance_type = "t2.small"
    subnet_ref    = "app"
    allow_port    = 8080
    allow_sg_cidr = ["192.168.4.0/24", "192.168.5.0/24"]
    capacity      = {
      desired     = 1
      max         = 1
      min         = 1
    }
  }

  shipping = {
    instance_type = "t2.small"
    subnet_ref    = "app"
    allow_port    = 8080
    allow_sg_cidr = ["192.168.4.0/24", "192.168.5.0/24"]
    capacity      = {
      desired     = 1
      max         = 1
      min         = 1
    }
  }

  payment = {
    instance_type = "t2.small"
    subnet_ref    = "app"
    allow_port    = 8080
    allow_sg_cidr = ["192.168.4.0/24", "192.168.5.0/24"]
    capacity      = {
      desired     = 1
      max         = 1
      min         = 1
    }
  }

}

db = {

  mongodb = {
    instance_type = "t2.small"
    subnet_ref    = "app"
    allow_port    = 27017
    allow_sg_cidr = ["192.168.4.0/24", "192.168.5.0/24"]

  }

  redis = {
    instance_type = "t2.small"
    subnet_ref    = "app"
    allow_port   = 6379
    allow_sg_cidr = ["192.168.4.0/24", "192.168.5.0/24"]

  }

  mysql = {
    instance_type = "t2.small"
    subnet_ref    = "app"
    allow_port    = 3306
    allow_sg_cidr = ["192.168.4.0/24", "192.168.5.0/24"]

  }

  rabbitmq = {
    instance_type = "t2.small"
    subnet_ref    = "app"
    allow_port    = 5672
    allow_sg_cidr = ["192.168.4.0/24", "192.168.5.0/24"]

  }
}

load_balancer = {

  private = {
    internal = true
    load_balancer_type = "application"
    allow_lb_sg_cidr = ["192.168.2.0/24", "192.168.3.0/24", "192.168.4.0/24", "192.168.5.0/24"]
    subnet_ref = "app"
    port              = 80
    listener_protocol          = "HTTP"
    ssl_policy        = "ELBSecurityPolicy-2016-08"
    certificate_arn   = null
  }

  public = {
    internal = false
    load_balancer_type = "application"
    allow_lb_sg_cidr = ["0.0.0.0/0"]
    subnet_ref = "public"
    listener_port              = 443
    listener_protocol          = "HTTPS"
    ssl_policy        = "ELBSecurityPolicy-2016-08"
    certificate_arn   = "to be checked"

  }
}