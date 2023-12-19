# terraform-kubernetes-elasticsearch
A Terraform module that deploys Elastic Search components such as ECK Operator, Elasticsearch, Kibana, and Beats.<br>
[Elastic Cloud on Kubernetes](https://www.elastic.co/guide/en/cloud-on-k8s/master/k8s-overview.html)<br>
[ElasticSearch](https://www.elastic.co/guide/en/cloud-on-k8s/master/k8s-elasticsearch-specification.html)<br>
[Kibana](https://www.elastic.co/guide/en/cloud-on-k8s/master/k8s-kibana.html)<br>
[Beats](https://www.elastic.co/guide/en/cloud-on-k8s/master/k8s-beat.html)<br>
[Terraform Helm Release](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release)<br>
[Terraform Kubernetes Manifest](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest)<br>


## Using specific versions of this module
You can use versioned release tags to ensure that your project using this module does not break when this module is updated in the future.<br>

<b>Repo latest commit</b><br>
```
module "elasticsearch" {
  source = "github.com/Medality-Health/terraform-kubernetes-elasticsearch"
  ...
```
<br>

<b>Tagged release</b><br>

```
module "elasticsearch" {
  source = "github.com/Medality-Health/terraform-kubernetes-elasticsearch?ref=1.0"
  ...
```
<br>

## Examples of using this module
This is an example of using this module something, fill in the rest.<br>

```
module "elasticsearch" {
  source = "github.com/Medality-Health/terraform-kubernetes-elasticsearch?ref=1.0"
  create_eck_operator        = true
  elastic_operator_version   = "2.6.1"
  elastic_operator_namespace = "elastic-system"
}
```

<br><br>
Module can be tested locally:<br>
```
git clone https://github.com/Medality-Health/terraform-kubernetes-elasticsearch.git
cd terraform-kubernetes-elasticsearch

cat <<EOF > elasticsearch.auto.tfvars
create_eck_operator        = true
elastic_operator_version   = "2.6.1"
elastic_operator_namespace = "elastic-system"

EOF

terraform init
terraform apply
```

