locals {
  name = "${var.name}-${random_string.suffix.result}"
}

################################################################################
# VPC
################################################################################

variable "name" {
  description = "Name"
  type        = string
  default     = "consul-ecs-demo"
}

variable "vpc_region" {
  type        = string
  description = "The AWS region to create resources in"
  default     = "us-east-1"
}


################################################################################
# EC2 Instance
################################################################################

variable "consul_server_count" {
  type        = number
  description = "Number of Consul Servers"
  default     = 1
}

variable "instance_type" {

}

variable "ami" {

}

variable "key_name" {

}

variable "ssh_user" {

}

variable "private_key_path" {

}

################################################################################
# Consul
################################################################################

variable "consul_bootstrap_token" {
  type        = string
  description = "Your Consul bootstrap token"
}

################################################################################
# Other
################################################################################

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

