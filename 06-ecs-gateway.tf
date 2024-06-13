# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

module "api_gateway" {
  source          = "hashicorp/consul-ecs/aws//modules/gateway-task"
  version         = "0.8.0"
  family          = "${var.name}-api-gateway"
  ecs_cluster_arn = aws_ecs_cluster.ecs_cluster.arn
  subnets         = module.vpc.private_subnets
  #security_groups     = [module.vpc.default_security_group_id]
  security_groups     = [aws_security_group.allow_all_into_ecs.id]
  log_configuration   = local.api_gateway_log_config
  consul_server_hosts = aws_instance.consul[0].public_dns
  kind                = "api-gateway"
  acls                = true
  tls                 = false
  #consul_ca_cert_arn            = module.dc1.dev_consul_server.ca_cert_arn
  additional_task_role_policies = [aws_iam_policy.execute_command.arn]
  lb_create_security_group      = false
  enable_transparent_proxy      = false
}

