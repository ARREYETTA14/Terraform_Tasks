###VPC

## VPC for Jetsky Application
resource "aws_vpc" "Jetsky_VPC" {
  cidr_block       = var.Jetsky_vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name_tag
  }
}

###SUBNETS FOR WEB,APP,DB

## Below code will create 2 Public Subnets for the web layer of Jetsky application
resource "aws_subnet" "Web_public_subnet_1" {
  vpc_id                  = aws_vpc.Jetsky_VPC.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = var.public_subnet_1_AZ
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_1_name_tag
  }
}

resource "aws_subnet" "Web_public_subnet_2" {
  vpc_id                  = aws_vpc.Jetsky_VPC.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = var.public_subnet_2_AZ
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_2_name_tag
  }
}

## Below code will create 2 Private Subnets for the app layer of the Jetsky application
resource "aws_subnet" "app_private_subnet_1" {
  vpc_id                  = aws_vpc.Jetsky_VPC.id
  cidr_block              = var.app_private_subnet_1_cidr
  availability_zone       = var.app_private_subnet_1_AZ
  map_public_ip_on_launch = false
  tags = {
    Name = var.app_private_subnet_1_name_tag
  }
}

resource "aws_subnet" "app_private_subnet_2" {
  vpc_id                  = aws_vpc.Jetsky_VPC.id
  cidr_block              = var.app_private_subnet_2_cidr
  availability_zone       = var.app_private_subnet_2_AZ
  map_public_ip_on_launch = false
  tags = {
    Name = var.app_private_subnet_2_name_tag
  }
}

## Below code will create 2 Private Subnets for the DB layer of the Jetsky application
resource "aws_subnet" "db_private_subnet_1" {
  vpc_id                  = aws_vpc.Jetsky_VPC.id
  cidr_block              = var.db_private_subnet_1_cidr
  availability_zone       = var.db_private_subnet_1_AZ
  map_public_ip_on_launch = false
  tags = {
    Name = var.db_private_subnet_1_name_tag
  }
}

resource "aws_subnet" "db_private_subnet_2" {
  vpc_id                  = aws_vpc.Jetsky_VPC.id
  cidr_block              = var.db_private_subnet_2_cidr
  availability_zone       = var.db_private_subnet_2_AZ
  map_public_ip_on_launch = false
  tags = {
    Name = var.db_private_subnet_2_name_tag
  }
}

### INTERNET GATEWAY FOR VPC

# Internet gateway creation & attachment to the Jetsky vpc
resource "aws_internet_gateway" "Jetsky_vpc_IGW" {
  vpc_id = aws_vpc.Jetsky_VPC.id

  tags = {
    Name = "${var.vpc_name_tag}-igw"
  }
}

### ELASTIC IP FOR PUBLIC SUBNET 1 AND PUBLIC SUBNET 2 NAT GATEWAYS

# Elastic IP for Public Subnet 1 Nat gateway

resource "aws_eip" "Public_Subnet_1_EIP" {
  domain = "vpc"
}


# Elastic IP for Public Subnet 2 Nat gateway

resource "aws_eip" "Public_Subnet_2_EIP" {
  domain = "vpc"
}


### NAT GATEWAY FOR PUBLIC SUBNET 1 AND PUBLIC SUBNET 2

# Nat gateway Public Subnet 1
resource "aws_nat_gateway" "Public_Subnet_1_NATGW" {
  allocation_id = aws_eip.Public_Subnet_1_EIP.id
  subnet_id     = aws_subnet.Web_public_subnet_1.id

  tags = {
    Name = "${var.public_subnet_1_name_tag}-Natgw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.Jetsky_vpc_IGW]
}

# Nat gateway Public Subnet 2
resource "aws_nat_gateway" "Public_Subnet_2_NATGW" {
  allocation_id = aws_eip.Public_Subnet_2_EIP.id
  subnet_id     = aws_subnet.Web_public_subnet_2.id

  tags = {
    Name = "${var.public_subnet_2_name_tag}-Natgw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.Jetsky_vpc_IGW]
}

### ROUTE TABLES 

# Public Subnets route table
resource "aws_route_table" "Public-route_table" {
  vpc_id = aws_vpc.Jetsky_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Jetsky_vpc_IGW.id
  }

  tags = {
    Name = "${var.vpc_name_tag}-Public_rt"
  }
}

# App Private Subnet_1 route table
resource "aws_route_table" "App_Private_Subnet_1-route_table" {
  vpc_id = aws_vpc.Jetsky_VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Public_Subnet_1_NATGW.id
  }

  tags = {
    Name = "${var.vpc_name_tag}-App_Private_Subnet_1_rt"
  }
}

# App Private Subnet_2 route table
resource "aws_route_table" "App_Private_Subnet_2-route_table" {
  vpc_id = aws_vpc.Jetsky_VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Public_Subnet_2_NATGW.id
  }

  tags = {
    Name = "${var.vpc_name_tag}-App_Private_Subnet_2_rt"
  }
}

# DB Private Subnet_1 route table
resource "aws_route_table" "DB_Private_Subnet_1-route_table" {
  vpc_id = aws_vpc.Jetsky_VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Public_Subnet_1_NATGW.id
  }

  tags = {
    Name = "${var.vpc_name_tag}-DB_Private_Subnet_1_rt"
  }
}

# DB Private Subnet_2 route table
resource "aws_route_table" "DB_Private_Subnet_2-route_table" {
  vpc_id = aws_vpc.Jetsky_VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Public_Subnet_1_NATGW.id
  }

  tags = {
    Name = "${var.vpc_name_tag}-DB_Private_Subnet_2_rt"
  }
}

### ROUTE TABLE ASSOCIATION WITH THE VARIOUS SUBNETS

# Associating the Web Public subnet 1 to the Public subnet route table
resource "aws_route_table_association" "Web_public_subnet_1_Ass" {
  subnet_id      = aws_subnet.Web_public_subnet_1.id
  route_table_id = aws_route_table.Public-route_table.id
}

# Associating the Web Public subnet 2 to the Public subnet route table
resource "aws_route_table_association" "Web_public_subnet_2_Ass" {
  subnet_id      = aws_subnet.Web_public_subnet_2.id
  route_table_id = aws_route_table.Public-route_table.id
}

# Associating the App Private subnet 1 to the App Private subnet 1 route table
resource "aws_route_table_association" "App_private_subnet_1_Ass" {
  subnet_id      = aws_subnet.app_private_subnet_1.id
  route_table_id = aws_route_table.App_Private_Subnet_1-route_table.id
}

# Associating the App Private subnet 2 to the App Private subnet 2 route table
resource "aws_route_table_association" "App_private_subnet_2_Ass" {
  subnet_id      = aws_subnet.app_private_subnet_2.id
  route_table_id = aws_route_table.App_Private_Subnet_2-route_table.id
}

# Associating the DB Private subnet 1 to the DB Private subnet 1 route table
resource "aws_route_table_association" "DB_private_subnet_1_Ass" {
  subnet_id      = aws_subnet.db_private_subnet_1.id
  route_table_id = aws_route_table.DB_Private_Subnet_1-route_table.id
}

# Associating the DB Private subnet 2 to the DB Private subnet 2 route table
resource "aws_route_table_association" "DB_private_subnet_2_Ass" {
  subnet_id      = aws_subnet.db_private_subnet_2.id
  route_table_id = aws_route_table.DB_Private_Subnet_2-route_table.id
}

### LOAD BALANCERS SECURITY GROUPS

## Frontend Load balancer Security Group

resource "aws_security_group" "Frontend_LB_SG" {
  name        = "Frontend_LB_Security_Group"
  description = "allows_inbound_traffic_from_users_from_internet"
  vpc_id      = aws_vpc.Jetsky_VPC

  ingress {
    description = "all_inbound_traffic_via_port_80_from_internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.Frontend_LB_SG_name_tag
  }

}

## Backend Load balancer Security Group

resource "aws_security_group" "Backend_LB_SG" {
  name        = "Backend_LB_Security_Group"
  description = "allows_inbound_traffic_from_webservers_SG"
  vpc_id      = aws_vpc.Jetsky_VPC

  ingress {
    description     = "all_inbound_traffic_via_port_80_from_webserver_sg"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.Webservers_SG.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.Backend_LB_SG_name_tag
  }

}

### SECURITY GROUP RULES FOR THE SERVERS

## Webserver Security Group Rule

resource "aws_security_group" "Webservers_SG" {
  name        = "Webservers_Security_Group"
  description = "Allows_all_inbound_traffic_via_frontend_LB"
  vpc_id      = aws_vpc.Jetsky_VPC

  ingress {
    description     = "all_traffic_via_port_80_from_frontend_LB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.Frontend_LB_SG.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.Webservers_Security_Group_name_tag
  }

}


## Appserver Security Group Rule

resource "aws_security_group" "Appservers_SG" {
  name        = "Appservers_Security_Group"
  description = "allows_inbound_traffic_via_backend_LB"
  vpc_id      = aws_vpc.Jetsky_VPC

  ingress {
    description = "Allows_traffic_via_port22_for_my_Ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.Jetsky_VPC.cidr_block]

  }

  ingress {
    description     = "all_traffic_via_port_80"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.Backend_LB_SG.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.Appservers_Security_Group_name_tag
  }

}


## Database Security Group Rule

resource "aws_security_group" "DBservers_SG" {
  name        = "DBservers_Security_Group"
  description = "allows_inbound_traffic_from_users_within_that_vpc"
  vpc_id      = aws_vpc.Jetsky_VPC

  ingress {
    description     = "Allows_traffic_via_port22_for_my_Ip"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = [aws_vpc.Jetsky_VPC.cidr_block]
    security_groups = [aws_security_group.Appservers_SG.id]
  }

  ingress {
    description     = "all_traffic_via_port_80"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.Appservers_SG]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.DBservers_Security_Group_name_tag
  }

}


