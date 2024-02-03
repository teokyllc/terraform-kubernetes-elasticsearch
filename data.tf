data "aws_region" "current" {}

data "aws_ssm_parameter" "static_elastic_passwd" {
  count = var.static_elastic_passwd ? 1 : 0
  name  = var.static_elastic_passwd_parameter_name
}