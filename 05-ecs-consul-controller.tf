# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

module "ecs_controller" {
  source  = "hashicorp/consul-ecs/aws//modules/controller"
  version = "0.8.0"

  name_prefix         = "${var.name}-ecs-controller"
  ecs_cluster_arn     = aws_ecs_cluster.ecs_cluster.arn
  region              = var.vpc_region
  subnets             = module.vpc.private_subnets
  security_groups     = [aws_security_group.allow_all_into_ecs.id]
  consul_server_hosts = local.consul_dns
  #consul_ca_cert_arn  = module.dc1.dev_consul_server.ca_cert_arn
  launch_type = "FARGATE"
  tls         = false

  # The Consul HTTP port
  http_config = {
    port  = 8500
    https = false
  }

  # The Consul gRPC port
  grpc_config = {
    port = 8502
  }

  consul_bootstrap_token_secret_arn = aws_secretsmanager_secret.bootstrap_token.arn
  log_configuration                 = local.ecs_controller_log_config

}