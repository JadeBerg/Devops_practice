output "alb-host" {
    value = aws_alb.main.dns_name
}