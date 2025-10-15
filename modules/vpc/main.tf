# VPC
resource "aws_vpc" "main" {
  cidr_block       = var.cidr

  tags = {
    Name = "${var.env}-vpc"
  }
}

# SUBNETS
resource "aws_subnet" "public" {
  count      = length(var.public_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name = "public-subnet-${split(",",var.availability_zone[count.index])[2]}"
  }
}

resource "aws_subnet" "web" {
  count      = length(var.web_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.web_subnets[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name = "web-subnet-${split(",",var.availability_zone[count.index])[2]}"
  }
}

resource "aws_subnet" "app" {
  count      = length(var.app_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.app_subnets[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name = "app-subnet-${split(",",var.availability_zone[count.index])[2]}"
  }
}

resource "aws_subnet" "db" {
  count      = length(var.db_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.db_subnets[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name = "db-subnet-${split(",",var.availability_zone[count.index])[2]}"
  }
}

# VPC PEERING CONNECTION
resource "aws_vpc_peering_connection" "main" {
  peer_vpc_id   = aws_vpc.main.id
  vpc_id        = var.default_vpc_id
  auto_accept   = true

  tags = {
    Name = "VPC-peering-default_vpc-new${aws_vpc.main.tags}"
  }
}

# VPC Peering Route
resource "aws_route" "default-vpc-peer-route" {
  route_table_id            = var.default_rt_id
  destination_cidr_block    = var.cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}

# NAT GATEWAY
resource "aws_eip" "eip" {
  count    = length(var.availability_zone)
  domain   = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  count = length(var.availability_zone)
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.public.*.id[count.index]

  tags = {
    Name = "NGW-${split(",",var.availability_zone[count.index])[2]}"
  }
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  count  = length(var.public_subnets)

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block                   = var.default_vpc_cidr
    vpc_peering_connection_id    = aws_vpc_peering_connection.main.id
  }

  tags = {
    Name = "public-rt-${split(",",var.availability_zone[count.index])[2]}"
  }
}

resource "aws_route_table" "web" {
  vpc_id = aws_vpc.main.id
  count  = length(var.web_subnets)

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.*.id[count.index]
  }

  route {
    cidr_block                  = var.default_vpc_cidr
    vpc_peering_connection_id   = aws_vpc_peering_connection.main.id
  }

  tags = {
    Name = "web-rt-${split(",",var.availability_zone[count.index])[2]}"
  }
}

resource "aws_route_table" "app" {
  vpc_id = aws_vpc.main.id
  count  = length(var.app_subnets)

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.*.id[count.index]
  }

  route {
    cidr_block                  = var.default_vpc_cidr
    vpc_peering_connection_id   = aws_vpc_peering_connection.main.id
  }

  tags = {
    Name = "app-rt-${split(",",var.availability_zone[count.index])[2]}"
  }
}

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.main.id
  count  = length(var.db_subnets)

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.*.id[count.index]
  }

  route {
    cidr_block                  = var.default_vpc_cidr
    vpc_peering_connection_id   = aws_vpc_peering_connection.main.id
  }

  tags = {
    Name = "db-rt-${split(",",var.availability_zone[count.index])[2]}"
  }
}

# Route Table Association
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public.*.id[count.index]
}

resource "aws_route_table_association" "web" {
  count          = length(var.web_subnets)
  subnet_id      = aws_subnet.web.*.id[count.index]
  route_table_id = aws_route_table.web.*.id[count.index]
}

resource "aws_route_table_association" "app" {
  count          = length(var.app_subnets)
  subnet_id      = aws_subnet.app.*.id[count.index]
  route_table_id = aws_route_table.app.*.id[count.index]
}

resource "aws_route_table_association" "db" {
  count          = length(var.db_subnets)
  subnet_id      = aws_subnet.db.*.id[count.index]
  route_table_id = aws_route_table.db.*.id[count.index]
}