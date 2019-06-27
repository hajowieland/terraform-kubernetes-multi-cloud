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

# variable "aks_node_count" {
#   description = "AKS Agent Pool nodes (e.g. `2`)"
#   type        = string
#   default     = "2"
# }



## Digital Ocean

variable "do_token" {
  description = "Digital Ocean Access token"
  type        = string
  default     = "DUMMY"
}

## Alibaba Cloud




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


