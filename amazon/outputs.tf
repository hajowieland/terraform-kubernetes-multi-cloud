output "config_map_aws_auth" {
  value = "${local.config_map_aws_auth}"
}

output "kubeconfig_path_aws" {
  value = "${local_file.kubeconfigaws.0.filename}"
}