## Google Cloud Platform

# The following outputs allow authentication and connectivity to the GKE Cluster
# by using certificate-based authentication.

output "kubeconfig_path_gke" {
  value = "${local_file.kubeconfiggke.0.filename}"
}


# ## Azure

output "kubeconfig_path_aks" {
  value = "${local_file.kubeconfigaks.0.filename}"
}


# ## Digital Ocean

output "kubeconfig_path_do" {
  value = "${local_file.kubeconfigdo.0.filename}"
}


## Alibaba Cloud

# output "ali_kube_config" {
#   value = alicloud_cs_managed_kubernetes.k8s.alikube_config
# }


### OCI

# Output the result
output "show-ads" {
  value = "${data.oci_identity_availability_domains.ADs.0.availability_domains}"
}


# output "kubeconfig_path_oci" {
#   value = "${local_file.kubeconfigoci.0.filename}"
# }


### AWS
output "config_map_aws_auth" {
  value = "${local.config_map_aws_auth}"
}

output "kubeconfig_path_aws" {
  value = "${local_file.kubeconfigaws.0.filename}"
}