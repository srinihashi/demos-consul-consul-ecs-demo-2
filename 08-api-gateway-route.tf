# API gateway's config entry - API Gateway Listener
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


# API gateway's config entry - HTTP Route
resource "consul_config_entry" "http_route" {
  depends_on = [consul_config_entry.api_gateway_listener]
  name       = "${var.name}-http-route"
  kind       = "http-route"
  provider   = consul.my-dc-1-cluster

  config_json = jsonencode({

    Parents = [
      {
        Kind        = "api-gateway"
        Name        = "${var.name}-api-gateway"
        SectionName = "api-gw-http-listener"
      }
    ]

    Rules = [
      {
        Matches = [
          {
            Method = ""
            Path = {
              Match = "prefix"
              Value = "/"
            }
          }
        ]
        Services = [
          {
            Name   = "frontend"
            Weight = 1
            Filters = {
            }
          }
        ]
      }
    ]
  })
}
