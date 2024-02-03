data "aws_region" "current" {}

data "aws_ssm_parameter" "static_elastic_passwd" {
  name = var.static_elastic_passwd_parameter_name
}