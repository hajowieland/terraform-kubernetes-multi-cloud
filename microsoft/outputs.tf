output "kubeconfig_path_aks" {
  value = "${local_file.kubeconfigaks.0.filename}"
}
