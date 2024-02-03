resource "helm_release" "elastic_operator" {
  count            = var.deploy_eck_operator ? 1 : 0
  name             = var.elastic_operator_helm_release_name
  repository       = "https://helm.elastic.co"
  chart            = "eck-operator"
  version          = var.elastic_operator_version
  namespace        = var.elastic_operator_namespace
  create_namespace = true
  atomic           = true
}

