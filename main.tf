## Google Cloud Platform GKE

resource "google_container_cluster" "primary" {
  provider = google
  name     = var.gke_name
  location = var.gcp_region
  project = var.gcp_project

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  node_config {
      service_account = var.gke_serviceaccount
  }
  

  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username = ""
    password = ""
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  provider = google
  project = var.gcp_project
  name       = var.gke_pool_name
  location   = var.gcp_region
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_node_count

  node_config {
    preemptible  = true
    machine_type = var.gke_node_type
    service_account = var.gke_serviceaccount

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

data "template_file" "kubeconfig" {
  template = "${file("${path.module}/gke_kubeconfig-template.yaml")}"

  vars = {
    cluster_name    = "${google_container_cluster.primary.name}"
    user_name       = "${google_container_cluster.primary.master_auth.0.username}"
    user_password   = "${google_container_cluster.primary.master_auth.0.password}"
    endpoint        = "${google_container_cluster.primary.endpoint}"
    cluster_ca      = "${google_container_cluster.primary.master_auth.0.cluster_ca_certificate}"
    client_cert     = "${google_container_cluster.primary.master_auth.0.client_certificate}"
    client_cert_key = "${google_container_cluster.primary.master_auth.0.client_key}"
  }
}

resource "local_file" "kubeconfiggke" {
  content  = "${data.template_file.kubeconfig.rendered}"
  filename = "${path.module}/kubeconfig_gke"
}


# Azure AKS

resource "azurerm_resource_group" "test" {
  name     = "acctestRG1"
  location = var.aks_region
}

resource "azurerm_kubernetes_cluster" "test" {
  name                = var.aks_name
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  dns_prefix          = "acctestagent1"

  agent_pool_profile {
    name            = "default"
    count           = var.aks_node_count
    vm_size         = var.aks_node_type
    os_type         = "Linux"
    os_disk_size_gb = var.aks_node_disk_size
  }

  service_principal {
    client_id     = var.az_client_id
    client_secret = var.az_client_secret
  }

  tags = {
    Environment = "Testing"
  }
}

resource "local_file" "kubeconfigaks" {
  content  = azurerm_kubernetes_cluster.test.kube_config_raw
  filename = "${path.module}/kubeconfig_aks"
}


## Digital Ocean Kubernetes (GA)

resource "digitalocean_kubernetes_cluster" "foo" {
  name    = var.do_k8s_name
  region  = var.do_region
  version = var.do_k8s_version

  node_pool {
    name       = var.do_k8s_pool_name
    size       = var.do_k8s_node_type
    node_count = var.do_k8s_node_count
  }
}

resource "local_file" "kubeconfigdo" {
  content  = digitalocean_kubernetes_cluster.foo.kube_config[0].raw_config
  filename = "${path.module}/kubeconfig_do"
}


## Amazon Web Services EKS


## Alicloud Managed Kubernetes Service

#####
#
# alicloud provider not yet compatible with Terraform 0.12 !
# https://github.com/terraform-providers/terraform-provider-alicloud/issues/1188
#
#####

# data "alicloud_zones" main {
#   available_resource_creation = "VSwitch"
# }

# data "alicloud_instance_types" "default" {
#     availability_zone = "${data.alicloud_zones.main.zones.0.id}"
#     cpu_core_count = var.ali_node_type_cpu
#     memory_size = var.ali_node_type_memory
# }

# resource "random_string" "alipassword" {
#   length  = 24
#   special = false
# }


# resource "alicloud_cs_managed_kubernetes" "k8s" {
#   name = "${var.ali_name}"
#   availability_zone = "${data.alicloud_zones.main.zones.0.id}"
#   new_nat_gateway = true
#   worker_instance_types = ["${data.alicloud_instance_types.default.instance_types.0.id}"]
#   worker_numbers = var.ali_node_count
#   password = random_string.alipassword.result
#   pod_cidr = "172.20.0.0/16"
#   service_cidr = "172.21.0.0/20"
#   install_cloud_monitor = true
#   slb_internet_enabled = true
#   worker_disk_category  = "cloud_efficiency"
# }

