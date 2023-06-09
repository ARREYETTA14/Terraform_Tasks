##### VALUES FOR THE NETWORK CONNECTION

### VPC VALUES

vpc_name_tag="Jetsky_VPC"
Jetsky_vpc_cidr="10.0.0.0/16"

### SUBNET VALUES

# Webserver Public subnet 1

public_subnet_1_cidr="10.1.0.0/24"
public_subnet_1_name_tag="Jetsky_WebPub_Sub_1"

# Webserver Public subnet 2

public_subnet_2_cidr="10.2.0.0/24"
public_subnet_2_name_tag="Jetsky_WebPub_Sub_2"

# Appserver Private subnet 1

app_private_subnet_1_cidr="10.3.0.0/24"
app_private_subnet_1_name_tag="Jetsky_AppPriv_Sub_1"

# Appserver Private subnet 2

app_private_subnet_2_cidr="10.4.0.0/24"
app_private_subnet_2_name_tag="Jetsky_AppPriv_Sub_2"

# DBserver Private subnet 1

db_private_subnet_1_cidr="10.5.0.0/24"
db_private_subnet_1_name_tag="Jetsky_DBPriv_Sub_1"

# DBserver Private subnet 2

db_private_subnet_2_cidr="10.6.0.0/24"
db_private_subnet_2_name_tag="Jetsky_DBPriv_Sub_2"

##### SERVER VALUES

# DBservers

db_instance_class="db.t3.micro"
db_password="Jetskyadmin1414@"
db_username="Jetskyuser"

##### LOADBALANCER VALUES

# Frontend 

Frontend_LB_SG_name_tag="Jetsky_Frontend_LB_SG"
Frontend_LB_name_tag="Jetsky_Frontend_LB_to_Webserver"

# Backend 

Backend_LB_SG_name_tag="Jetsky_Backend_LB_SG"
Backend_LB_name_tag="Jetsky_Backend_LB_to_Appserver"

##### SERVERS SECURITY Group


# Webserver
Webservers_Security_Group_name_tag="Webservers_SG"

# Appserver
Appservers_Security_Group_name_tag="Appservers_SG"

# Database
DBservers_Security_Group_name_tag="Database_SG"