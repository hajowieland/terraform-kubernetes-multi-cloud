## Google Cloud
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
  description = "GKE cluster name (e.g. `dev-cluster-playground-gke`)"
  type        = string
  default     = "dev-cluster-playground-gke"
}

variable "gke_pool_name" {
  description = "GKE Node Pool name (e.g. `dev-cluster-gke-nodepool`)"
  type        = string
  default     = "dev-cluster-nodepool-gke"
}

variable "gke_node_type" {
  description = "GKE Node Instance Type (e.g. `n1-standard-1` => 1vCPU, 3.75 GB RAM)"
  type        = string
  default     = "n1-standard-1"
}

variable "gke_node_count" {
  description = "GKE number of nodes in node pool (e.g. `2`)"
  default     = 2
}

variable "gke_serviceaccount" {
    description = "GCP service account for GKE (e.g. `default`)"
    type = string
    default = "default"
}

## Azure

variable "az_client_id" {
  description = "Azure Service Principal appId"
  type = string
}

variable "az_client_secret" {
  description = "Azure Service Principal password"
  type = string
}

variable "az_tenant_id" {
  description = "Azure Service Principal tenant"
  type = string
}
variable "aks_region" {
  description = "AKS region (e.g. `westeurope`)"
  type        = string
  default     = "westeurope"
}

variable "aks_name" {
  description = "AKS cluster name (e.g. `dev-cluster-playground-aks`)"
  type        = string
  default     = "dev-cluster-playground-aks"
}

variable "aks_node_type" {
  description = "AKS Agent Pool Instance Type (e.g. `Standard_D1_v2` => 1vCPU, 3.75 GB RAM)"
  type        = string
  default     = "Standard_D1_v2"
}

variable "aks_node_count" {
  description = "AKS Agent Pool nodes (e.g. `2`)"
  type        = string
  default     = "2"
}

variable "aks_node_disk_size" {
    description = "AKS Agent Pool instance disk size in GB (e.g. `30` => minimum: 30GB, maximum: 1024)"
    type = string
    default = 30
}


## Digital Ocean
variable "do_token" {
  description = "Digital Ocean Access token"
  type = string
}

variable "do_region" {
    description = "Digital Ocean Region to use (e.g. `fra1` => Fraknfurt)"
    type = string
    default = "fra1"
}


variable "do_k8s_name" {
  description = "Digital Ocean Kubernetes cluster name (e.g. `dev-cluster-playground-do`)"
  type        = string
  default     = "dev-cluster-playground-do"
}

variable "do_k8s_version" {
    description = "Digital Ocean Kubernetes version to use (e.g. `1.14.2-do.0`)"
    type = string
    default = "1.14.2-do.0"
}

variable "do_k8s_node_count" {
  description = "Digital Ocean Kubernets nodes (e.g. `2`)"
  type        = string
  default     = 2
}

variable "do_k8s_node_type" {
  description = "Digital Ocean Kubernetse Node Plan (e.g. `s-1vcpu-2gb` => 1vCPU, 2GB RAM)"
  type        = string
  default     = "s-1vcpu-2gb"
}


variable "do_k8s_pool_name" {
  description = "Digital Ocean Kubernetse Node Pool name (e.g. `dev-cluster-do-nodepool`)"
  type        = string
  default     = "dev-cluster-nodepool-do"
}


## Alibaba Cloud

# variable "ali_node_type_cpu" {
#   description = "Alibaba Cloud CPU cores for node type (e.g. `1`)"
#   type = string
#   default = 1
# }

# variable "ali_node_type_memory" {
#   description = "Alibaba Cloud RAM memory in GB (e.g. `2`)"
#   type = string
#   default = 2
# }

# variable "ali_name" {
#   description = "Alibaba Managed Kubernetes cluster name (e.g. `dev-cluster-playground-ali`)"
#   type = string
#   default = "dev-cluster-playground-ali"
# }

# variable "ali_node_count" {
#   description = "Alibaba Managed Kubernetes cluster worker node count (e.g. `[2]`)"
#   type = list
#   default = [2]
# }