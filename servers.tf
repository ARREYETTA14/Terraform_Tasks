### LOCALS FOR THE SUBNET IDS

# Public Subnets in whcih the Webservers are to be hosted

locals {
  webserver_subnet_ids = [
 "aws_subnet.Web_public_subnet_1.id",
 "aws_subnet.Web_public_subnet_2.id"
 ]
}

# Private Subnets in whcih the Appservers are to be hosted

locals {
  Appserver_subnet_ids = [
   "aws_subnet.app_private_subnet_1.id",
   "aws_subnet.app_private_subnet_2.id" 
  ]
}


# Private Subnets in whcih the database is to be hosted

locals {
  db_subnet_group_name_ids = [
    "aws_subnet.db_private_subnet_1.id", 
    "aws_subnet.db_private_subnet_2.id"
  ]
}

### LOCALS FOR THE SECURITY GROUPS
# Frontend_LB_SG

locals {
  Frontend_Loadbalancer = [aws_security_group.Frontend_LB_SG.id]
}

# Backend_LB_SG

locals {
  Backend_Loadbalancer = [aws_security_group.Backend_LB_SG.id]
}

# Webservers SG locals

locals {
  Webservers_SG = [aws_security_group.Webservers_SG.id]
}

# Appservers SG locals

locals {
  Appservers_SG = [aws_security_group.Appservers_SG.id]
}




### SERVERS FOR THE JETSKY APPLICATION


#Webserver instances

resource "aws_instance" "Web_server_Jetsky" {
  count           = length(local.webserver_subnet_ids)
  subnet_id       = local.webserver_subnet_ids[count.index]
  ami             = var.webserver_ami_id[count.index]
  instance_type   = var.webserver_instance_type[count.index]
  security_groups = local.Webservers_SG
  tags = {
    Name = var.webserver_name_tag[count.index]
  }
}

# Appserver Instances

resource "aws_instance" "App_server_Jetsky" {
  count           = length(local.Appserver_subnet_ids)
  subnet_id       = local.Appserver_subnet_ids[count.index]
  ami             = var.Appserver_ami_id[count.index]
  instance_type   = var.Appserver_instance_type[count.index]
  security_groups = local.Appservers_SG
  tags = {
    Name = var.Appserver_name_tag[count.index]
  }
}

## DB Instance

resource "aws_db_instance" "DB_server_Jetsky" {
  count = length(local.db_subnet_group_name_ids)
  allocated_storage          = 50
  auto_minor_version_upgrade = true
  backup_retention_period    = 7
  db_subnet_group_name       = local.db_subnet_group_name_ids[count.index]
  engine                     = "mysql"
  engine_version             = "8.0.32"
  db_name                    = var.db_name_tag
  instance_class             = var.db_instance_class
  multi_az                   = true
  password                   = var.db_password
  username                   = var.db_username
  storage_encrypted          = true


}

### LOAD BALANCERS TO DISTRIBUTE TRAFFIC

## Frontend Load Balancer

resource "aws_lb" "Frontend_LB" {
  name               = "Frontend-LB-for-JETSKY-App"
  internal           = false
  load_balancer_type = "application"
  security_groups    = local.Frontend_Loadbalancer
  subnets            = local.webserver_subnet_ids

  enable_deletion_protection = true

  tags = {
    Name = var.Frontend_LB_name_tag
  }
}

resource "aws_lb_target_group" "Frontend_LB_TG" {
  name        = "Frontend-LB-Target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.Jetsky_VPC.id
}

resource "aws_lb_listener" "Front_end" {
  load_balancer_arn = aws_lb.Frontend_LB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Frontend_LB_TG.arn
  }
}

## Backend Load Balancer

resource "aws_lb" "Backend_LB" {
  name               = "Backend-LB-for-Jetsky-App"
  internal           = false
  load_balancer_type = "application"
  security_groups    = local.Backend_Loadbalancer
  subnets            = local.Appserver_subnet_ids

  enable_deletion_protection = true

  tags = {
    Name = var.Backend_LB_name_tag
  }
}

resource "aws_lb_target_group" "Backend_LB_TG" {
  name        = "Backend-LB-Target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.Jetsky_VPC.id
}

resource "aws_lb_listener" "Back_end" {
  load_balancer_arn = aws_lb.Backend_LB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Backend_LB_TG.arn
  }
}