resource "kubernetes_namespace_v1" "elasticsearch_namespace" {
  count = var.deploy_elasticsearch ? 1 : 0
  metadata {
    name = var.elasticsearch_namespace
  }
}

resource "kubernetes_secret_v1" "elastic_user_password" {
  count = var.static_elastic_passwd ? 1 : 0
  metadata {
    name = "${var.elasticsearch_name}-es-elastic-user"
    namespace = kubernetes_namespace_v1.elasticsearch_namespace[0].metadata[0].name
  }

  data = {
    elastic = data.aws_ssm_parameter.static_elastic_passwd.value
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
          "count" = var.elasticsearch_master_node_set_count
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
                "storageClassName" = var.elasticsearch_storage_class_name
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
          "count" = var.elasticsearch_data_node_set_count
          "name" = "data"
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
                    "storage" = "${var.elasticsearch_data_role_disk_size_in_gb}Gi"
                  }
                }
                "storageClassName" = var.elasticsearch_storage_class_name
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