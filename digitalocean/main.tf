resource "digitalocean_kubernetes_cluster" "foo" {
  count   = var.enable_digitalocean ? 1 : 0
  name    = "${var.do_k8s_name}-${var.random_cluster_suffix}"
  region  = var.do_region
  version = var.do_k8s_version

  node_pool {
    name       = var.do_k8s_pool_name
    size       = var.do_k8s_node_type
    node_count = var.do_k8s_nodes
  }

  tags = [
    "k8s"
  ]
}

resource "digitalocean_kubernetes_node_pool" "bar" {
  count   = var.enable_digitalocean ? 1 : 0
  cluster_id = "${digitalocean_kubernetes_cluster.foo[count.index].id}"

  name       = "backend-pool"
  size       = var.do_k8s_nodepool_type
  node_count = var.do_k8s_odepool_size
  tags       = ["backend"]
}

resource "local_file" "kubeconfigdo" {
  count    = var.enable_digitalocean ? 1 : 0
  content  = digitalocean_kubernetes_cluster.foo.0.kube_config[0].raw_config
  filename = "${path.module}/kubeconfig_do"
}
