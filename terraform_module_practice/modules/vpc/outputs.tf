output "vpc_id" {
    value = aws_vpc.my_vps.id
}

output "environment" {
    value = var.environment
}

output "app_name" {
    value = "WebPage"
}