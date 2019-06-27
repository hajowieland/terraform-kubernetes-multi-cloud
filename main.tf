## Create a random id as suffix for the cluster name
resource "random_id" "cluster_name" {
  byte_length = 6
}

## Get your workstation external IPv4 address:
data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  workstation-external-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"
}

## Amazon Web Services EKS
module "amazon" {
  source = "./amazon"

  enable_amazon = var.enable_amazon
  workstation_ipv4 = local.workstation-external-cidr
  random_cluster_suffix = random_id.cluster_name.hex
}

## Digital Ocean Kubernetes (GA)
module "digitalocean" {
  source = "./digitalocean"

  enable_digitalocean = var.enable_digitalocean
  workstation_ipv4 = local.workstation-external-cidr
  random_cluster_suffix = random_id.cluster_name.hex
  do_token = var.do_token
}


## Google Cloud Platform GKE
module "google" {
  source = "./google"

  enable_google = var.enable_google
  gcp_project = var.gcp_project
  workstation_ipv4 = local.workstation-external-cidr
  random_cluster_suffix = random_id.cluster_name.hex
}

## Microsoft Azure AKS
module "microsoft" {
  source = "./microsoft"

  enable_microsoft = var.enable_microsoft
  workstation_ipv4 = local.workstation-external-cidr
  random_cluster_suffix = random_id.cluster_name.hex
  az_tenant_id = var.az_tenant_id
  az_client_id = var.az_client_id
  az_client_secret = var.az_client_secret
}

## Oracle Cloud Infrastructure Container Service for Kubernetes
module "oracle" {
  source = "./oracle"

  enable_oracle = var.enable_oracle
  workstation_ipv4 = local.workstation-external-cidr
  random_cluster_suffix = random_id.cluster_name.hex

  oci_user_ocid = var.oci_user_ocid
  oci_tenancy_ocid = var.oci_tenancy_ocid
  oci_fingerprint = var.oci_fingerprint

}




resource "local_file" "kubeconfigaws" {
  count = var.enable_amazon ? 1 : 0
  content = module.amazon.kubeconfig_path_aws
  filename = "${path.module}/kubeconfig_aws"

  depends_on = [module.amazon]
}


resource "local_file" "kubeconfiggke" {
  count = var.enable_google ? 1 : 0
  content = module.google.kubeconfig_path_gke
  filename = "${path.module}/kubeconfig_gke"

  depends_on = [module.google]
}


resource "local_file" "kubeconfigaks" {
  count = var.enable_microsoft ? 1 : 0
  content = module.microsoft.kubeconfig_path_aks
  filename = "${path.module}/kubeconfig_aks"

  depends_on = [module.microsoft]
}

resource "local_file" "kubeconfigoci" {
  count = var.enable_oracle ? 1 : 0
  content = module.oracle.kubeconfig_path_oci
  filename = "${path.module}/kubeconfig_oci"

  depends_on = [module.oracle]
}





# This data sources are included for ease of sample architecture deployment
# and can be swapped out as necessary.



# Alicloud Managed Kubernetes Service








### Combine kubeconfig_* files into one kubeconfig
#resource "null_resource" "kubeconfig" {
#  provisioner "local-exec" {
#    command = "for i in $(ls kubeconfig_*); do cat $i >> kubeconfig && printf '\n---\n\n' >> kubeconfig; done"
#  }
#}
