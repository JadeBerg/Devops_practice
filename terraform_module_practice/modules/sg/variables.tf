variable "allowed_ports" {
    description = "List of allowed ports"
    type = list(any)
    default = ["443", "80", "8080", "22"]
}

variable "vpc_id" {}

variable "environment" {}