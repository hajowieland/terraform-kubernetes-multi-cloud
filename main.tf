## Alicloud Managed Kubernetes Service (ACK)
module "alibaba" {
  source  = "hajowieland/k8s/alicloud"

  enable_alibaba = var.enable_alibaba

  ali_access_key = var.ali_access_key
  ali_secret_key = var.ali_secret_key

  ack_node_count = var.nodes
}

## Amazon Web Services (EKS)
module "amazon" {
  source  = "hajowieland/k8s/aws"

  enable_amazon = var.enable_amazon

}

## Digital Ocean Kubernetes ("DOK")
module "digitalocean" {
  source  = "hajowieland/k8s/digitalocean"

  enable_digitalocean = var.enable_digitalocean

  do_token = var.do_token

  do_k8s_nodepool_size = var.nodes
}

## Google Cloud Platform (GKE)
module "google" {
  source  = "hajowieland/k8s/google"

  enable_google = var.enable_google

  gcp_project = var.gcp_project

  gke_nodes = var.nodes
}

## Microsoft Azure (AKS)
module "microsoft" {
  source  = "hajowieland/k8s/azurerm"

  enable_microsoft = var.enable_microsoft

  az_tenant_id     = var.az_tenant_id
  az_client_id     = var.az_client_id
  az_client_secret = var.az_client_secret

  aks_nodes = var.nodes
}

## Oracle Cloud Infrastructure Container Service for Kubernetes (OKE)
module "oracle" {
  source  = "hajowieland/k8s/oci"

  enable_oracle = var.enable_oracle

  oci_user_ocid    = var.oci_user_ocid
  oci_tenancy_ocid = var.oci_tenancy_ocid
  oci_fingerprint  = var.oci_fingerprint

  oke_node_pool_size = var.nodes
}


# Create kubeconfig files in main module directory
# (will be created in submodule directories, too)

resource "local_file" "kubeconfigali" {
  count    = var.enable_alibaba ? 1 : 0
  content  = module.alibaba.kubeconfig_path_ali
  filename = "${path.module}/kubeconfig_ali"

  depends_on = [module.alibaba]
}

resource "local_file" "kubeconfigaws" {
  count    = var.enable_amazon ? 1 : 0
  content  = module.amazon.kubeconfig_path_aws
  filename = "${path.module}/kubeconfig_aws"

  depends_on = [module.amazon]
}

resource "local_file" "kubeconfigdo" {
  count    = var.enable_digitalocean ? 1 : 0
  content  = module.digitalocean.kubeconfig_path_do
  filename = "${path.module}/kubeconfig_do"

  depends_on = [module.alibaba]
}

resource "local_file" "kubeconfiggke" {
  count    = var.enable_google ? 1 : 0
  content  = module.google.kubeconfig_path_gke
  filename = "${path.module}/kubeconfig_gke"

  depends_on = [module.google]
}

resource "local_file" "kubeconfigaks" {
  count    = var.enable_microsoft ? 1 : 0
  content  = module.microsoft.kubeconfig_path_aks
  filename = "${path.module}/kubeconfig_aks"

  depends_on = [module.microsoft]
}

resource "local_file" "kubeconfigoci" {
  count    = var.enable_oracle ? 1 : 0
  content  = module.oracle.kubeconfig_path_oci
  filename = "${path.module}/kubeconfig_oci"

  depends_on = [module.oracle]
}
