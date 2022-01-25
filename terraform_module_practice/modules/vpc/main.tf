resource "aws_vpc" "my_vps" {
    cidr_block = var.cidr
    
    tags = {
        Name = "${var.environment}-vpc"
    }
}