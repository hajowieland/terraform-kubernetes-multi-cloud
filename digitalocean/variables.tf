variable "enable_digitalocean" {
  description = "Enable / Disable Digital Ocean (e.g. `1`)"
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

variable "nodepool_size" {
  description = "Nodepool size (e.g. `3`)"
  default = 3
}

variable "random_cluster_suffix" {
  description = "Random 6 byte hex suffix for cluster name"
  type = string
}

variable "do_token" {
  description = "Digital Ocean Access token"
  type        = string
  default     = "DUMMY"
}

variable "do_region" {
  description = "Digital Ocean Region to use (e.g. `fra1` => Frankfurt)"
  type        = string
  default     = "fra1"
}


variable "do_k8s_name" {
  description = "Digital Ocean Kubernetes cluster name (e.g. `k8s-do`)"
  type        = string
  default     = "k8s-do"
}

variable "do_k8s_version" {
  description = "Digital Ocean Kubernetes version to use (e.g. `1.14.2-do.0`)"
  type        = string
  default     = "1.14.2-do.0"
}

# variable "do_k8s_node_count" {
#   description = "Digital Ocean Kubernets nodes (e.g. `2`)"
#   type        = string
#   default     = 2
# }

variable "do_k8s_node_type" {
  description = "Digital Ocean Kubernetse Node Plan (e.g. `s-1vcpu-2gb` => 1vCPU, 2GB RAM)"
  type        = string
  default     = "s-1vcpu-2gb"
}

variable "do_k8s_nodepool_type" {
  description = "Digital Ocean Kubernetes additional Node Pool Type (e.g. `s-1vcpu-2gb` => 1vCPU, 2GB RAM)"
  type = string
  default = "s-1vcpu-2gb"
}

variable "do_k8s_pool_name" {
  description = "Digital Ocean Kubernetse Node Pool name (e.g. `k8s-do-nodepool`)"
  type        = string
  default     = "dev-cluster-nodepool-do"
}