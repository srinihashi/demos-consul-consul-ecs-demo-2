terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #version = ">= 4.47.0"
      version = "5.53.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2"
    }
  }
}

provider "aws" {
  region = var.vpc_region
}

provider "consul" {
  alias = "my-dc-1-cluster"
  #address    = "http://${aws_instance.consul[0].public_dns}:8500"
  address    = "${local.consul_dns}:8500"
  datacenter = "my-dc-1"
  #token      = modaws_secretsmanager_secret.bootstrap_token.value
  token = var.consul_bootstrap_token
}
