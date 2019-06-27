variable "enable_amazon" {
  description = "Enable / Disable Amazon (e.g. `1`)"
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
  description = "AWS VPC CIDR block (e.g. `10.0.23.0/16`)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnets" {
  description = "List of 8-bit numbers of subnets base_cidr_block"
  default     = 2
}

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

variable "aws_eks_version" {
  description = "AWS EKS cluster version (e.g. `1.13`)"
  type = string
  default = "1.13"
}

