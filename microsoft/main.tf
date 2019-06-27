
resource "azurerm_resource_group" "test" {
  count    = var.enable_microsoft ? 1 : 0
  name     = "K8sRG1"
  location = var.aks_region
}

resource "azurerm_kubernetes_cluster" "test" {
  count               = var.enable_microsoft ? 1 : 0
  name                = "${var.aks_name}-${var.random_cluster_suffix}"
  location            = azurerm_resource_group.test.0.location
  resource_group_name = azurerm_resource_group.test.0.name
  dns_prefix          = "k8s1"

  agent_pool_profile {
    name            = var.aks_agent_pool_name
    count           = var.nodes
    vm_size         = var.aks_node_type
    os_type         = "Linux"
    os_disk_size_gb = var.aks_node_disk_size
  }

  service_principal {
    client_id     = var.az_client_id
    client_secret = var.az_client_secret
  }

  tags = {
    Project = "k8s",
    ManagedBy = "terraform"
  }
}

resource "local_file" "kubeconfigaks" {
  count    = var.enable_microsoft ? 1 : 0
  content  = azurerm_kubernetes_cluster.test.0.kube_config_raw
  filename = "${path.module}/kubeconfig_aks"
}