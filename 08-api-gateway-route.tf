
# API gateway's config entry - HTTP Route (API gateway path / --> service-b)
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
            Name   = "service-b"
            Weight = 1
            Filters = {
            }
          }
        ]
      }
    ]
  })
}
