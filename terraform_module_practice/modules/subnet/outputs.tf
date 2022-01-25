output "publicSubnetCIDR" {
    value = var.publicSubnetCIDR
}

output "subnet_id" {
    value = aws_subnet.publicsubnet.*.id
}