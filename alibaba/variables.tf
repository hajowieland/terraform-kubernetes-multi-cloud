# variable "enable_amazon" {
#   description = "Enable / Disable Amazon (e.g. `1`)"
#   type        = bool
#   default     = false
# }

# variable "workstation_ipv4" {
#   description = "Workstation external IPv4 address"
#   type = string
# }

# variable "nodes" {
#   description = "Worker nodes (e.g. `2`)"
#   default     = 2
# }

# variable "random_cluster_suffix" {
#   description = "Random 6 byte hex suffix for cluster name"
#   type = string
# }

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
#   description = "Alibaba Managed Kubernetes cluster name (e.g. `k8s-ali`)"
#   type = string
#   default = "k8s-ali"
# }

# variable "ali_node_count" {
#   description = "Alibaba Managed Kubernetes cluster worker node count (e.g. `[2]`)"
#   type = list
#   default = [2]
# }