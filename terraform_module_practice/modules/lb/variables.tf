variable "vpc_id" {}

variable "environment" {}

variable "app_name" {}

variable "subnet_id" {}

variable "vpc_security_group_ids" {}

variable "instance" {}

variable "app_port" {
    default = 80
}