resource "kubernetes_manifest" "elasticsearch_gateway" {
  count    = var.enable_istio ? 1 : 0
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind" = "Gateway"
    "metadata" = {
      "name" = "elasticsearch-gateway"
      "namespace" = var.kibana_namespace
    }
    "spec" = {
      "selector" = {
        "istio" = var.istio_ingress_gateway_name
      }
      "servers" = [
        {
          "hosts" = var.istio_dns_names
          "port" = {
            "name" = "http"
            "number" = 80
            "protocol" = "HTTP"
          }
          "tls" = {
            "httpsRedirect" = true
          }
        },
        {
          "hosts" = var.istio_dns_names
          "port" = {
            "name" = "https"
            "number" = 443
            "protocol" = "HTTPS"
          }
          "tls" = {
            "credentialName" = var.istio_tls_secret_name
            "mode" = "SIMPLE"
          }
        },
      ]
    }
  }

  field_manager {
    force_conflicts = true
  }
}

resource "kubernetes_manifest" "elasticsearch_virtualservice" {
  count    = var.enable_istio ? 1 : 0
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind" = "VirtualService"
    "metadata" = {
      "name" = "elasticsearch"
      "namespace" = var.kibana_namespace
    }
    "spec" = {
      "gateways" = ["elasticsearch-gateway"]
      "hosts" = [
        var.elasticsearch_dns_name
      ]
      "http" = [
        {
          "match" = [
            {
              "uri" = {
                "prefix" = "/"
              }
            },
          ]
          "route" = [
            {
              "destination" = {
                "host" = "${var.elasticsearch_name}-es-http.${var.elasticsearch_namespace}.svc.cluster.local"
                "port" = {
                  "number" = 9200
                }
              }
            },
          ]
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "kibana_virtualservice" {
  count    = var.enable_istio ? 1 : 0
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind" = "VirtualService"
    "metadata" = {
      "name" = "kibana"
      "namespace" = var.elasticsearch_namespace
    }
    "spec" = {
      "gateways" = ["elasticsearch-gateway"]
      "hosts" = [
        var.kibana_dns_name
      ]
      "http" = [
        {
          "match" = [
            {
              "uri" = {
                "prefix" = "/"
              }
            },
          ]
          "route" = [
            {
              "destination" = {
                "host" = "${var.kibana_name}-kb-http.${var.elasticsearch_namespace}.svc.cluster.local"
                "port" = {
                  "number" = 5601
                }
              }
            },
          ]
        },
      ]
    }
  }
}
