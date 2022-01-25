## Terraform Module Practice Example

This example create:

1) One VPC:
{
    resource "aws_vpc" "my_vps" {
        cidr_block = var.cidr
        
        tags = {
            Name = "${var.environment}-vpc"
        }
    }
}

-----------------------------------------------------------------------------------------------------------------------------------

2) Three instances:
{
    data "aws_ami" "latest_amazon_linux" {
        owners = ["amazon"]
        most_recent = true
        filter{
            name = "name"
            values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
        }
    }

    resource "aws_instance" "my_Amazon_Linux" {

        count = length(var.publicSubnetCIDR)
        ami = data.aws_ami.latest_amazon_linux.id
        instance_type = var.instance_type
        subnet_id = var.subnet_id[count.index]
        vpc_security_group_ids = var.vpc_security_group_ids.*.id

        user_data = file("./modules/ec2/apache_server.sh")

        tags = {
            Name = "My Amazon Linux Server with Apache"
        }
    }
}

-----------------------------------------------------------------------------------------------------------------------------------

3) Three public subnets: 
{
    data "aws_availability_zones" "availableAZ" {}

    resource "aws_subnet" "publicsubnet" {
        count = length(var.publicSubnetCIDR)
        cidr_block = tolist(var.publicSubnetCIDR)[count.index]
        vpc_id = var.vpc_id
        map_public_ip_on_launch = true
        availability_zone = data.aws_availability_zones.availableAZ.names[count.index]

        tags = {
            Name = "${var.environment}-publicsubnet-${count.index + 1}"
            AZ = data.aws_availability_zones.availableAZ.names[count.index]
            Environment = "${var.environment}-publicsubnet"
        }

        depends_on = [var.vpc_id]
    }

    resource "aws_internet_gateway" "internetgateway" {
        vpc_id = var.vpc_id

        tags = {
            Name = "${var.environment}-InternetGateway"
        }

        depends_on = [var.vpc_id]
    }

    resource "aws_route_table" "publicroutetable" {
        vpc_id = var.vpc_id

        route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.internetgateway.id
        }

        tags = {
            Name = "${var.environment}-publicroutetable"
        }

        depends_on = [aws_internet_gateway.internetgateway]
    }

    resource "aws_route_table_association" "routeTableAssociationPublicRoute" {
        count = length(var.publicSubnetCIDR)
        route_table_id = aws_route_table.publicroutetable.id
        subnet_id = aws_subnet.publicsubnet[count.index].id

        depends_on = [aws_subnet.publicsubnet, aws_route_table.publicroutetable]
    }
}

-----------------------------------------------------------------------------------------------------------------------------------

4) One security group:
{
    resource "aws_security_group" "SecurityGroup_EC2inPublicSubnet" {
        name = "Security Group for EC2 instances public subnets"
        vpc_id = var.vpc_id

        dynamic "ingress" {
            for_each = var.allowed_ports
            content {
                from_port = ingress.value
                to_port = ingress.value
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
            }
        }

        egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }

        tags = {
            Name = "${var.environment}-publicsubnetEC2-SG"
        }    
    }
}

-----------------------------------------------------------------------------------------------------------------------------------

5) Apache server on instances with wimple web-page:
{
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform! Using external sh"  >  /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
}

-----------------------------------------------------------------------------------------------------------------------------------