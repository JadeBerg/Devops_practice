data "aws_availability_zones" "availableAZ" {}

# Public Subnet
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