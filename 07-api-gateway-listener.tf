
# API gateway's config entry - API Gateway Listener
resource "consul_config_entry" "api_gateway_listener" {
  depends_on = [module.api_gateway]
  name       = "${var.name}-api-gateway"
  kind       = "api-gateway"
  provider   = consul.my-dc-1-cluster

  config_json = jsonencode({
    Listeners = [
      {
        Name     = "api-gw-http-listener"
        Port     = 8443
        Protocol = "http"
      }
    ]
  })
}

# Set proxy defaults to protocol = http
resource "consul_config_entry" "api_gateway_proxy_defaults" {
  depends_on = [module.api_gateway]
  kind       = "proxy-defaults"
  name       = "global"
  provider   = consul.my-dc-1-cluster

  config_json = jsonencode({
    Config = [{
      protocol = "http"
      }
    ]
  })
}


