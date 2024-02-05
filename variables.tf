variable "deploy_eck_operator" {
  type        = bool
  description = "Deploys the Elastic Cloud for Kubernetes."
  default     = false
}

variable "elastic_operator_version" {
  type        = string
  description = "The version of the ECK operator to deploy."
  default     = null
}

variable "elastic_operator_namespace" {
  type        = string
  description = "The namespace for the ECK deployment."
  default     = "elastic-system"
}

variable "elastic_operator_helm_release_name" {
  type        = string
  description = "Then name for the helm release for ECK."
  default     = "elastic-system"
}

variable "deploy_elasticsearch" {
  type        = bool
  description = "Deploys an ElasticSearch cluster."
  default     = false
}

variable "create_elasticsearch_namespace" {
  type        = bool
  description = "If enabled, created a new namespace for ElasticSearch."
  default     = false
}

variable "elasticsearch_namespace" {
  type        = string
  description = "The namespace for the ElasticSearch deployment."
  default     = "elastic-system"
}

variable "elasticsearch_password" {
  type        = string
  description = "The ElasticSearch password."
  default     = null
}

variable "elasticsearch_name" {
  type        = string
  description = "The name of the ElasticSearch object."
  default     = null
}

variable "elasticsearch_version" {
  type        = string
  description = "The version of ElasticSearch to deploy."
  default     = null
}

variable "elasticsearch_base_url" {
  type        = string
  description = "The URL for ElasticSearch."
  default     = null
}

variable "elasticsearch_disable_self_signed_tls" {
  type        = bool
  description = "If true, the ElasticSearch self signed TLS certificate will be disabled."
  default     = false
}

variable "elasticsearch_master_node_set_count" {
  type        = string
  description = "The number of nodes in the master node set."
  default     = null
}

variable "elasticsearch_data_node_set_count" {
  type        = string
  description = "The number of nodes in the data node set."
  default     = null
}

variable "elasticsearch_storage_class_name" {
  type        = string
  description = "The name of the Kubernetes storage class to use for persistent data storage."
  default     = null
}

variable "elasticsearch_master_role_disk_size_in_gb" {
  type        = string
  description = "The size of the persistent disk on the master role pods."
  default     = null
}

variable "elasticsearch_data_role_disk_size_in_gb" {
  type        = string
  description = "The size of the persistent disk on the data role pods."
  default     = null
}

variable "static_elastic_passwd" {
  type        = bool
  description = "If true allows a static password from a SSM parameter."
  default     = false
}

variable "static_elastic_passwd_parameter_name" {
  type        = string
  description = "The name of a SSM parameter with the elastic admin password."
  default     = null
}

variable "deploy_kibana" {
  type        = bool
  description = "Deploys a Kibana frontend."
  default     = false
}

variable "kibana_name" {
  type        = string
  description = "The name of the Kibana object."
  default     = null
}

variable "create_kibana_namespace" {
  type        = bool
  description = "If enabled, created a new namespace for Kibana."
  default     = false
}

variable "kibana_namespace" {
  type        = string
  description = "The name of the Kibana namespace."
  default     = null
}

variable "kibana_version" {
  type        = string
  description = "The version of Kibana to deploy."
  default     = null
}

variable "enable_istio" {
  type        = bool
  description = "Enables Istio services.  Certificate, Gateway & Virtual Services."
  default     = false
}

variable "istio_dns_names" {
  type        = list(any)
  description = "A list of hostnames for the ElasticSearch apps."
  default     = null
}

variable "elasticsearch_dns_name" {
  type        = string
  description = "A domain name for ElasticSearch."
  default     = null
}

variable "kibana_dns_name" {
  type        = string
  description = "A domain name for Kibana."
  default     = null
}

variable "istio_tls_secret_name" {
  type        = string
  description = "The name of a TLS secret for Istio Gateway."
  default     = null
}

variable "istio_ingress_gateway_name" {
  type        = string
  description = "The name of the Istio Ingress Gateway."
  default     = null
}