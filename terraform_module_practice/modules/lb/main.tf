resource "aws_alb" "main" {
    name = "${var.app_name}-${var.environment}-LoadBalancer"
    subnets = var.subnet_id.*
    security_groups = [var.vpc_security_group_ids.id]
}

resource "aws_lb_target_group" "app" {
    name = "${var.app_name}-${var.environment}-tg"
    port = var.app_port
    protocol = "HTTP"
    vpc_id = var.vpc_id
    target_type = "instance"

    health_check {
        healthy_threshold = "3"
        interval = "30"
        protocol = "HTTP"
        matcher = "200"
        timeout = "3"
        unhealthy_threshold = "2"
    }
}

resource "aws_alb_listener" "front" {
    load_balancer_arn = aws_alb.main.id
    port = var.app_port

    default_action {
        target_group_arn = aws_lb_target_group.app.id
        type = "forward" 
    }
}

resource "aws_lb_target_group_attachment" "alb_tg_attach" {
    target_group_arn = aws_lb_target_group.app.arn
    port = var.app_port
    count = length(var.instance)
    target_id = var.instance[count.index].id
}