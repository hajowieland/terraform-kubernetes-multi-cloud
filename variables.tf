variable "enable_google" {
  description = "Enable / Disable Google (e.g. `1`)"
  type        = bool
  default     = false
}

variable "enable_microsoft" {
  description = "Enable / Disable Google (e.g. `1`)"
  type        = bool
  default     = false
}

variable "enable_alibaba" {
  description = "Enable / Disable Google (e.g. `1`)"
  type        = bool
  default     = false
}

variable "enable_digitalocean" {
  description = "Enable / Disable Google (e.g. `1`)"
  type        = bool
  default     = false
}

variable "enable_amazon" {
  description = "Enable / Disable Google (e.g. `1`)"
  type        = bool
  default     = false
}

variable "enable_oracle" {
  description = "Enable / Disable Google (e.g. `1`)"
  type        = bool
  default     = false
}


variable "nodes" {
  description = "Worker nodes (e.g. `2`)"
  default     = 2
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

## Azure

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


# variable "aks_node_count" {
#   description = "AKS Agent Pool nodes (e.g. `2`)"
#   type        = string
#   default     = "2"
# }

variable "aks_node_disk_size" {
  description = "AKS Agent Pool instance disk size in GB (e.g. `30` => minimum: 30GB, maximum: 1024)"
  type        = string
  default     = 30
}


## Digital Ocean
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


variable "do_k8s_pool_name" {
  description = "Digital Ocean Kubernetse Node Pool name (e.g. `k8s-do-nodepool`)"
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
#   description = "Alibaba Managed Kubernetes cluster name (e.g. `k8s-ali`)"
#   type = string
#   default = "k8s-ali"
# }

# variable "ali_node_count" {
#   description = "Alibaba Managed Kubernetes cluster worker node count (e.g. `[2]`)"
#   type = list
#   default = [2]
# }


### Oracle Cloud Infrastructure

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



### Amazon

variable "aws_region" {
  description = "AWS region (e.g. `eu-central-1` => Frankfurt)"
  type        = string
  default     = "eu-central-1"
}

variable "aws_profile" {
  description = "AWS cli profile (e.g. `default`)"
  type = string
  default = "default"
}

variable "aws_access_key" {
  description = "AWS access key id (AWS_ACCESS_KEY_ID)"
  type        = string
  default     = ""
}


variable "aws_secret_access_key" {
  description = "AWS secret access key (AWS_SECRET_ACCESS_KEY)"
  type        = string
  default     = ""
}


variable "aws_cluster_name" {
  description = "AWS ELS cluster name (e.g. `k8s-eks`)"
  type        = string
  default     = "k8s-eks"
}

variable "aws_instance_type" {
  description = "AWS EC2 Instance Type (e.g. `t3.medium`)"
  type        = string
  default     = "t3.medium"
}

