variable "enable_google" {
  description = "Enable / Disable Google (e.g. `1`)"
  type        = bool
  default     = false
}

variable "workstation_ipv4" {
  description = "Workstation external IPv4 address"
  type = string
}

variable "nodes" {
  description = "Worker nodes (e.g. `2`)"
  default     = 2
}

variable "random_cluster_suffix" {
  description = "Random 6 byte hex suffix for cluster name"
  type = string
}


variable "gcp_project" {
  description = "GCP Project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region (e.g. `europe-west3` => Frankfurt)"
  type        = string
  default     = "europe-west3"
}

variable "gke_name" {
  description = "GKE cluster name (e.g. `k8s-gke`)"
  type        = string
  default     = "k8s-gke"
}

variable "gke_pool_name" {
  description = "GKE Node Pool name (e.g. `k8s-gke-nodepool`)"
  type        = string
  default     = "k8s-gke-nodepool"
}

variable "gke_node_type" {
  description = "GKE Node Instance Type (e.g. `n1-standard-1` => 1vCPU, 3.75 GB RAM)"
  type        = string
  default     = "n1-standard-1"
}

# variable "gke_node_count" {
#   description = "GKE number of nodes in node pool (e.g. `2`)"
#   default     = 2
# }

variable "gke_serviceaccount" {
  description = "GCP service account for GKE (e.g. `default`)"
  type        = string
  default     = "default"
}

variable "gke_oauth_scopes" {
  description = "GCP OAuth scopes for GKE (https://www.terraform.io/docs/providers/google/r/container_cluster.html#oauth_scopes)"
  type = list
  default = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
  ]
}