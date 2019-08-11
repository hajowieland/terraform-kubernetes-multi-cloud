variable "enable_google" {
  description = "Enable / Disable Google"
  type        = bool
  default     = false
}

variable "enable_microsoft" {
  description = "Enable / Disable Microsoft"
  type        = bool
  default     = false
}

variable "enable_alibaba" {
  description = "Enable / Disable Alibaba"
  type        = bool
  default     = false
}

variable "enable_digitalocean" {
  description = "Enable / Disable DigitalOcean"
  type        = bool
  default     = false
}

variable "enable_amazon" {
  description = "Enable / Disable Amazon"
  type        = bool
  default     = false
}

variable "enable_oracle" {
  description = "Enable / Disable Oracle"
  type        = bool
  default     = false
}


variable "nodes" {
  description = "Worker nodes (e.g. `2`)"
  default     = 2
}

variable "ali_access_key" {
  description = "Alibaba Cloud access key"
  type        = string
  default     = ""
}

variable "ali_secret_key" {
  description = "Alibaba Cloud secret key"
  type        = string
  default     = ""
}


## Google Cloud
variable "gcp_project" {
  description = "GCP Project ID"
  type        = string
  default     = ""
}

variable "gcp_region" {
  description = "GCP region (e.g. `europe-west3` => Frankfurt)"
  type        = string
  default     = "europe-west3"
}



## Azure

variable "az_client_id" {
  description = "Azure Service Principal appId"
  type        = string
  default     = ""
}

variable "az_client_secret" {
  description = "Azure Service Principal password"
  type        = string
  default     = ""
}

variable "az_tenant_id" {
  description = "Azure Service Principal tenant"
  type        = string
  default     = ""
}

# variable "aks_node_count" {
#   description = "AKS Agent Pool nodes (e.g. `2`)"
#   type        = string
#   default     = "2"
# }



## Digital Ocean

variable "do_token" {
  description = "Digital Ocean Access token"
  type        = string
  default     = ""
}

## Alibaba Cloud




### Oracle Cloud Infrastructure

variable "oci_user_ocid" {
  description = "OCI User OCID"
  type        = string
  default     = ""
}

variable "oci_tenancy_ocid" {
  description = "OCI Tenancy OCID"
  type        = string
  default     = ""
}

variable "oci_fingerprint" {
  description = "OCI SSH key fingerprint"
  type        = string
  default     = ""
}

### Amazon

variable "aws_region" {
  description = "AWS region (e.g. `eu-central-1` => Frankfurt)"
  type        = string
  default     = "eu-central-1"
}

variable "aws_profile" {
  description = "AWS cli profile (e.g. `default`)"
  type        = string
  default     = "default"
}


