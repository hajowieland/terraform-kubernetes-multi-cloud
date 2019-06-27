
output "kubeconfig_path_gke" {
  value = "${local_file.kubeconfiggke.0.filename}"
}
