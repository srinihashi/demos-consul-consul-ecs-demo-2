/****
# Ingress rule for the API Gateway task that accepts traffic from the API gateway's LB
resource "aws_security_group_rule" "gateway_task_ingress_rule" {
  type                     = "ingress"
  description              = "Ingress rule for ${var.name}-api-gateway task"
  from_port                = 8443
  to_port                  = 8443
  protocol                 = "-1"
  source_security_group_id = aws_security_group.load_balancer.id
  security_group_id        = module.vpc.default_security_group_id
}
****/