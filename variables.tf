###VPC VARIABLES

## Variable for VPC name tag
variable "vpc_name_tag" {}
variable "Jetsky_vpc_cidr" {}

###SUBNETS VARIABLES

## variables for web public subnet 1
variable "public_subnet_1_cidr" {}
variable "public_subnet_1_AZ" {
  default = ["eu-north-1a"]
}
variable "public_subnet_1_name_tag" {}

## variables for web public subnet 2
variable "public_subnet_2_cidr" {}
variable "public_subnet_2_AZ" {
  default = ["eu-north-1b"]
}
variable "public_subnet_2_name_tag" {}

## variables for app private subnet 1
variable "app_private_subnet_1_cidr" {}
variable "app_private_subnet_1_AZ" {
  default = ["eu-north-1a"]
}
variable "app_private_subnet_1_name_tag" {}

## variables for app private subnet 2
variable "app_private_subnet_2_cidr" {}
variable "app_private_subnet_2_AZ" {
  default = ["eu-north-1b"]
}
variable "app_private_subnet_2_name_tag" {}

## variables for db private subnet 1
variable "db_private_subnet_1_cidr" {}
variable "db_private_subnet_1_AZ" {
  default = ["eu-north-1a"]
}
variable "db_private_subnet_1_name_tag" {}

## variables for db private subnet 2
variable "db_private_subnet_2_cidr" {}
variable "db_private_subnet_2_AZ" {
  default = ["eu-north-1b"]
}
variable "db_private_subnet_2_name_tag" {}

###SERVERS FOR JETSKY APPLICATION

## Webservers variables
variable "webserver_subnet_id" {
  default = [
    "aws_subnet.Web_public_subnet_1.id", 
    "aws_subnet.Web_public_subnet_2.id"
  ]
}
variable "webserver_ami_id" {
  default = [
    "ami-01a7573bb17a45f12", 
    "ami-01a7573bb17a45f12"
  ]
}
variable "webserver_instance_type" {
  default = [
    "t2.medium", 
    "t2.medium"
  ]
}
variable "webserver_name_tag" {
  default = [
    "Jetsky_webserver_1", 
    "Jetsky_webserver_2"
  ]
}

## App servers variables
variable "Appserver_subnet_id" {
  default = [
    "aws_subnet.app_private_subnet_1.id", 
    "aws_subnet.app_private_subnet_2.id"
  ]
}
variable "Appserver_ami_id" {
  default = [
    "ami-01a7573bb17a45f12", 
    "ami-01a7573bb17a45f12"
  ]
}
variable "Appserver_instance_type" {
  default = [
    "t2.medium", 
    "t2.medium"
  ]
}
variable "Appserver_name_tag" {
  default = [
    "Jetsky_webserver_1", 
    "Jetsky_webserver_2"
  ]
}

## Variables for the Jetsky Database
variable "db_name_tag" {
  default = "JetSky_Database"
}
variable "db_instance_class" {}
variable "db_password" {}
variable "db_username" {}


### LOADBALANCER SECURITY GROUPS 

## Frontend Loadbalancer
variable "Frontend_LB_SG_name_tag" {}

## Backend Loadbalancer
variable "Backend_LB_SG_name_tag" {}


### SERVERS SECURITY GROUPS

## variable for webservers
variable "Webservers_Security_Group_name_tag" {}

## variable for Appservers
variable "Appservers_Security_Group_name_tag" {}

## variable for DBservers
variable "DBservers_Security_Group_name_tag" {}


### LOAD BALANCER VARIABLES

## variable for Frontend Loadbalancer name tag
variable "Frontend_LB_name_tag" {}

## variable for Backend Loadbalancer name tag
variable "Backend_LB_name_tag" {}










