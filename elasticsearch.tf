resource "kubernetes_namespace_v1" "elasticsearch_namespace" {
  count = var.deploy_elasticsearch ? 1 : 0
  metadata {
    name = var.elasticsearch_namespace
  }
}

resource "kubernetes_secret_v1" "elastic_user_password" {
  count = var.deploy_elasticsearch ? 1 : 0
  metadata {
    name = "${var.elasticsearch_name}-es-elastic-user"
    namespace = kubernetes_namespace_v1.elasticsearch_namespace[0].metadata[0].name
  }

  data = {
    elastic = var.elasticsearch_password
  }

  type = "Opaque"

  lifecycle {
    ignore_changes = [metadata[0].labels]
  }
}

resource "kubernetes_manifest" "elasticsearch" {
  count      = var.deploy_elasticsearch ? 1 : 0
  depends_on = [helm_release.elastic_operator]
  manifest   = {
    "apiVersion" = "elasticsearch.k8s.elastic.co/v1"
    "kind" = "Elasticsearch"
    "metadata" = {
      "name" = var.elasticsearch_name
      "namespace" = kubernetes_namespace_v1.elasticsearch_namespace[0].metadata[0].name
    }
    "spec" = {
      "http" = {
        "tls" = {
          "selfSignedCertificate" = {
            "disabled" = var.elasticsearch_disable_self_signed_tls
          }
        }
      }
      "nodeSets" = [
        {
          "config" = {
            "node.roles" = [
              "master",
              "ingest",
            ]
            "node.store.allow_mmap" = false
          }
          "count" = 2
          "name" = "master"
          "podTemplate" = {
            "metadata" = {
              "annotations" = {
                "traffic.sidecar.istio.io/excludeInboundPorts" = "9300"
                "traffic.sidecar.istio.io/excludeOutboundPorts" = "9300"
                "traffic.sidecar.istio.io/includeInboundPorts" = "*"
              }
            }
          }
          "volumeClaimTemplates" = [
            {
              "metadata" = {
                "name" = "elasticsearch-data"
              }
              "spec" = {
                "accessModes" = [
                  "ReadWriteOnce",
                ]
                "resources" = {
                  "requests" = {
                    "storage" = "${var.elasticsearch_master_role_disk_size_in_gb}Gi"
                  }
                }
                "storageClassName" = "gp2"
              }
            },
          ]
        },
        {
          "config" = {
            "node.roles" = [
              "data",
            ]
            "node.store.allow_mmap" = false
          }
          "count" = 2
          "name" = "data"
          "podTemplate" = {
            "metadata" = {
              "annotations" = {
                "traffic.sidecar.istio.io/excludeInboundPorts" = "9300"
                "traffic.sidecar.istio.io/excludeOutboundPorts" = "9300"
                "traffic.sidecar.istio.io/includeInboundPorts" = "*"
              }
            }
            "spec" = {
              "containers" = [
                {
                  "name" = "elasticsearch"
                  "resources" = {
                    "limits" = {
                      "memory" = "${var.elasticsearch_data_memory_limit_in_gb}Gi"
                    }
                    "requests" = {
                      "memory" = "${var.elasticsearch_data_memory_limit_in_gb}Gi"
                    }
                  }
                },
              ]
            }
          }
          "volumeClaimTemplates" = [
            {
              "metadata" = {
                "name" = "elasticsearch-data"
              }
              "spec" = {
                "accessModes" = [
                  "ReadWriteOnce",
                ]
                "resources" = {
                  "requests" = {
                    "storage" = "${var.elasticsearch_data_role_disk_size_in_gb}Gi"
                  }
                }
                "storageClassName" = "gp2"
              }
            },
          ]
        },
      ]
      "version" = var.elasticsearch_version
    }
  }
  field_manager {
    force_conflicts = true
  }
}