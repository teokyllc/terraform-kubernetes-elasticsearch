resource "kubernetes_manifest" "kibana" {
  count      = var.deploy_kibana ? 1 : 0
  depends_on = [helm_release.elastic_operator]
  manifest   = {
    "apiVersion" = "kibana.k8s.elastic.co/v1"
    "kind" = "Kibana"
    "metadata" = {
      "name" = var.kibana_name
      "namespace" = kubernetes_namespace_v1.elasticsearch_namespace[0].metadata[0].name
    }
    "spec" = {
      "config" = {
        "server.publicBaseUrl" = var.kibana_public_base_url
      }
      "count" = 2
      "elasticsearchRef" = {
        "name" = var.elasticsearch_name
        "namespace" = kubernetes_namespace_v1.elasticsearch_namespace[0].metadata[0].name
      }
      "http" = {
        "tls" = {
          "selfSignedCertificate" = {
            "disabled" = var.elasticsearch_disable_self_signed_tls
          }
        }
      }
      "version" = var.elasticsearch_version
    }
  }
}
