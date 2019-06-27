output "kubeconfig_path_oci" {
  value = "${local_file.kubeconfigoci.0.filename}"
}
