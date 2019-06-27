resource "random_id" "username" {
  count    = var.enable_google ? 1 : 0
  byte_length = 14
}

resource "random_id" "password" {
  count    = var.enable_google ? 1 : 0
  byte_length = 18
}

resource "google_container_cluster" "primary" {
  count    = var.enable_google ? 1 : 0
  name     = "${var.gke_name}-${var.random_cluster_suffix}"
  location = var.gcp_region
  project  = var.gcp_project

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  node_config {
    service_account = var.gke_serviceaccount
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = true
    }
  }

  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username = "${random_id.username[count.index].hex}"
    password = "${random_id.password[count.index].hex}"

    client_certificate_config {
      issue_client_certificate = true
    }
  }

  // (Required for private cluster, optional otherwise) network (cidr) from which cluster is accessible
  master_authorized_networks_config {
    cidr_blocks {
        display_name = "gke-admin"
        cidr_block   = var.workstation_ipv4
    }
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  count      = var.enable_google ? 1 : 0
  project    = var.gcp_project
  name       = var.gke_pool_name
  location   = var.gcp_region
  cluster    = google_container_cluster.primary.0.name
  node_count = var.nodes

  node_config {
    preemptible     = true
    machine_type    = var.gke_node_type
    service_account = var.gke_serviceaccount

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = var.gke_oauth_scopes

    labels = {
      Project = "K8s"
    }

    tags = ["k8s"]
  }
}


data "template_file" "kubeconfig" {
  count    = var.enable_google ? 1 : 0
  template = "${file("${path.module}/gke_kubeconfig-template.yaml")}"

  vars = {
    cluster_name = google_container_cluster.primary.0.name
    endpoint         = google_container_cluster.primary.0.endpoint
    user_name       = "${google_container_cluster.primary.0.master_auth.0.username}"
    user_password   = "${google_container_cluster.primary.0.master_auth.0.password}"
    cluster_ca       = google_container_cluster.primary.0.master_auth.0.cluster_ca_certificate
    client_cert      = google_container_cluster.primary.0.master_auth.0.client_certificate
    client_cert_key  = google_container_cluster.primary.0.master_auth.0.client_key
  }
}

resource "local_file" "kubeconfiggke" {
  count    = var.enable_google ? 1 : 0
  content  = "${data.template_file.kubeconfig.0.rendered}"
  filename = "${path.module}/kubeconfig_gke"
}
