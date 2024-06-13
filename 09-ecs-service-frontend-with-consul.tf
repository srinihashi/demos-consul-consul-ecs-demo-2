# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

module "frontend" {
  source  = "hashicorp/consul-ecs/aws//modules/mesh-task"
  version = "0.8.0"

  # The name this service will be registered as in Consul.
  consul_service_name = "frontend"

  # The port that this application listens on.
  port = 3000

  # Address of the Consul server
  #consul_server_hosts       = "${aws_instance.consul[1].public_dns}"
  consul_server_hosts = local.consul_dns

  enable_transparent_proxy = false

  # Configures ACLs for the mesh-task.
  acls = true

  # The Consul HTTP port
  http_config = {
    port  = 8500
    https = false
  }

  # The Consul gRPC port
  grpc_config = {
    port = 8502
  }

  family            = "${local.name}-frontend"
  cpu               = 512
  memory            = 1024
  log_configuration = local.frontend_log_config

  # The ECS container definition
  container_definitions = [
    {
      name      = "frontend"
      image     = "hashicorpdemoapp/frontend:v1.0.2"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "NEXT_PUBLIC_PUBLIC_API_URL"
          value = "/"
        }
      ]
      mountPoints = []
      volumesFrom = []

      logConfiguration = local.frontend_log_config
    }
  ]

  depends_on = [aws_ecs_cluster.ecs_cluster, module.ecs_controller]
}

resource "aws_ecs_service" "frontend" {
  name            = "frontend-consul"
  cluster         = aws_ecs_cluster.ecs_cluster.arn
  task_definition = module.frontend.task_definition_arn
  desired_count   = 1

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.allow_all_into_ecs.id]
  }

  launch_type            = "FARGATE"
  propagate_tags         = "TASK_DEFINITION"
  enable_execute_command = true

  depends_on = [aws_ecs_cluster.ecs_cluster]
}
