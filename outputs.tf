################################################################################
# VPC
################################################################################

output "region" {
  value = var.vpc_region
}

output "vpc-id" {
  value = module.vpc.vpc_id
}

################################################################################
# Consul Service(s)
################################################################################

output "consulBootstrapToken" {
  value = aws_secretsmanager_secret.bootstrap_token.arn
}

output "Consul_ssh" {
  value = "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${aws_instance.consul[0].public_dns}"
}

output "ConsulServer" {
  value = "http://${aws_instance.consul[0].public_dns}:8500"
}

