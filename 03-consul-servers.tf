locals {
  consul_dns = aws_instance.consul[0].public_dns
}

resource "aws_instance" "consul" {
  count                       = var.consul_server_count
  ami                         = var.ami # Amazon Linux 2 AMI (change as needed)
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  tags = {
    Name = "ECS-Demo-ConsulServer"
  }
  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install -y yum-utils shadow-utils
                sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
                sudo yum -y install consul
                EOF

  # Security group to allow Consul communication
  vpc_security_group_ids = [aws_security_group.consul_sg.id]

  # Key pair for SSH access
  key_name = var.key_name
}
