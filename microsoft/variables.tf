variable "enable_microsoft" {
  description = "Enable / Disable Microsoft (e.g. `1`)"
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

variable "az_client_id" {
  description = "Azure Service Principal appId"
  type        = string
}

variable "az_client_secret" {
  description = "Azure Service Principal password"
  type        = string
}

variable "az_tenant_id" {
  description = "Azure Service Principal tenant"
  type        = string
}

variable "aks_region" {
  description = "AKS region (e.g. `westeurope`)"
  type        = string
  default     = "westeurope"
}

variable "aks_name" {
  description = "AKS cluster name (e.g. `k8s-aks`)"
  type        = string
  default     = "k8s-aks"
}

variable "aks_node_type" {
  description = "AKS Agent Pool Instance Type (e.g. `Standard_D1_v2` => 1vCPU, 3.75 GB RAM)"
  type        = string
  default     = "Standard_D1_v2"
}

variable "aks_agent_pool_name" {
  description = "AKS Node Pool name (e.g. `k8s-aks-nodepool`)"
  type        = string
  default     = "k8snodepool"
}

variable "aks_node_disk_size" {
  description = "AKS Agent Pool instance disk size in GB (e.g. `30` => minimum: 30GB, maximum: 1024)"
  type        = string
  default     = 30
}
