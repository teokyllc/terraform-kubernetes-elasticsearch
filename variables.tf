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
  description = "The name of ElasticSearch to deploy."
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

variable "elasticsearch_data_memory_limit_in_gb" {
  type        = string
  description = "The memory limit on the data role pods."
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

variable "kibana_public_base_url" {
  type        = string
  description = "The public base URL for Kibana."
  default     = null
}

variable "enable_istio" {
  type        = bool
  description = "Enables Istio services.  Certificate, Gateway & Virtual Services."
  default     = false
}

variable "es_dns_names" {
  type        = list(any)
  description = "A list of hostnames for the ElasticSearch."
  default     = null
}

variable "root_app_hostname" {
  type        = string
  description = "A root domain name for ElasticSearch DNS."
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