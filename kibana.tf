resource "kubernetes_namespace_v1" "kibana_namespace" {
  count = var.create_kibana_namespace ? 1 : 0
  metadata {
    name = var.kibana_namespace
  }
}

resource "kubernetes_manifest" "kibana" {
  count      = var.deploy_kibana ? 1 : 0
  depends_on = [helm_release.elastic_operator]
  manifest   = {
    "apiVersion" = "kibana.k8s.elastic.co/v1"
    "kind" = "Kibana"
    "metadata" = {
      "name" = var.kibana_name
      "namespace" = var.create_kibana_namespace ? kubernetes_namespace_v1.kibana_namespace[0].metadata[0].name : var.kibana_namespace
    }
    "spec" = {
      "config" = {
        "server.publicBaseUrl" = var.kibana_dns_name
      }
      "count" = 2
      "elasticsearchRef" = {
        "name" = var.elasticsearch_name
        "namespace" = var.elasticsearch_namespace
      }
      "http" = {
        "tls" = {
          "selfSignedCertificate" = {
            "disabled" = var.elasticsearch_disable_self_signed_tls
          }
        }
      }
      "version" = var.kibana_version
    }
  }
}
