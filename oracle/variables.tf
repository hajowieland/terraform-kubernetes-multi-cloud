
variable "enable_oracle" {
  description = "Enable / Disable Oracle (e.g. `1`)"
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


variable "cidr_block" {
  description = "OCI VCN CIDR block (e.g. `10.0.23.0/16`)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnets" {
  description = "List of 8-bit numbers of subnets base_cidr_block"
  default     = 2
}

variable "lbs" {
  description = "List of 8-bit numbers of LoadBalancer base_cidr_block"
  default     = 10
}


variable "oci_user_ocid" {
  description = "OCI User OCID"
  type        = string
}

variable "oci_tenancy_ocid" {
  description = "OCI Tenancy OCID"
  type        = string
}

variable "oci_fingerprint" {
  description = "OCI SSH key fingerprint"
  type        = string
}

variable "oci_region" {
  description = "OCI Region to use (e.g. `eu-frankfurt-1` => Frankfurt)"
  type        = string
  default     = "eu-frankfurt-1"
}

variable "oci_private_key_path" {
  description = "OCI Private key path (e.g. `~/.oci/oci_api_key.pem`)"
  type        = string
  default     = "~/.oci/oci_api_key.pem"
}

variable "oci_public_key_path" {
  description = "OCI Public key path (e.g. `~/.oci/oci_api_key_public.pem`)"
  type        = string
  default     = "~/.oci/oci_api_key_public.pem"
}


variable "oci_policy_name" {
  description = "OCI Identitfy Policy name (e.g. `k8spolicy`)"
  type        = string
  default     = "k8spolicy"
}

variable "oci_policy_description" {
  description = "OCI Identitfy Policy description"
  type        = string
  default     = "Allow OKE to manage all resources"
}

variable "oci_policy_statements" {
  description = "OCI Policy Statements in policy language"
  type        = list
  default     = ["Allow service OKE to manage all-resources in tenancy"]
}

# OCI VCN:
variable "oci_vcn_cidr_prefix" {
  description = "OCI VCN CIDR Prefix (e.g. `10.0`)"
  type        = string
  default     = "10.0"
}
# variable "oci_vcn_cidr_block" {
#   description = "OCI VCN CIDR block (e.g. `10.0.23.0/16`)"
#   type = string
#   default = "10.0.0.0/16"
# }

variable "oci_subnet_cidr_block" {
  description = "OCI VCN SubnetCIDR block (e.g. `10.0.23.1/24`)"
  type        = string
  default     = "10.23.1.0/24"
}


variable "oci_cluster_kubernetes_version" {
  description = "OCI Kubernetes version to use (e.g. `1.12.7`)"
  type        = string
  default     = "v1.12.7"
}

variable "oci_cluster_name" {
  description = "OCI Kubernetes cluster name (e.g. `k8soci`)"
  type        = string
  default     = "k8soci"
}

variable "oci_node_pool_name" {
  description = "OCI Kubernetes Node Pool name (e.g. `k8s-nodepool-oci`)"
  type        = string
  default     = "k8s-nodepool-oci"
}


variable "oci_cluster_options_add_ons_is_kubernetes_dashboard_enabled" {
  description = "OCI Enable Kubernetes Dashboard (e.g. `false`)"
  type        = string
  default     = "false"
}


variable "oci_cluster_options_add_ons_is_tiller_enabled" {
  description = "OCI Enable Tiller (e.g. `false`)"
  type        = string
  default     = "false"
}


variable "oci_node_pool_node_shape" {
  description = "OCI Kubernetse Node Pool Shapes (e.g. `VM.Standard2.1` => 1vCPU, 15GB RAM)"
  type        = string
  default     = "VM.Standard2.1"
}


variable "oci_subnet_prohibit_public_ip_on_vnic" {
  description = "OCI VCN Subnet prohibits assigning public IPs or not (e.g. `false`)"
  type        = string
  default     = "true"
}


# variable "oci_node_pool_quantity_per_subnet" {
#   description = "OCI Kubernetse nodes in each subnet (e.g. `2`)"
#   type        = string
#   default     = 2
# }

variable "oci_node_pool_ssh_public_key" {
  description = "OCI SSH Public Key to add to each node in the node pool (e.g. `~/.ssh/id_rsa.pub`)"
  type        = string
  default     = "~/.oci/oci_api_key_public.pem"
}


variable "oci_node_pool_node_image_name" {
  description = "OCI Container Kubernetes Node Pool Image name {e.g. `Oracle-Linux-7.6`}"
  type        = string
  default     = "Oracle-Linux-7.6"
}

variable "oci_cluster_kube_config_expiration" { default = 2592000 }
variable "oci_cluster_kube_config_token_version" { default = "1.0.0" }
