output "vpc_id" {
    value = module.vpc.vpc_id
}

output "subnet_id" {
    value = module.subnet.subnet_id
}

output "alb-host" {
    value = module.lb.alb-host
}