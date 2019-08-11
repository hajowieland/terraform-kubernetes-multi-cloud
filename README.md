# Terraform Kubernetes Multi-Cloud

Terraform code for creating a handful of simple managed Kubernetes clusters on multiple public cloud platforms.

_Managed_ in this context means the master nodes (= control plane) are managed by the cloud platform provider. We only create the service, the worker nodes and the bare minimum of everything else to get a working K8s cluster.

<center>
ℹ️ **This is for demonstration and/or learning purposes.** ℹ️
ℹ️ **Please do not use this in production** ℹ️
</center>

## Public Cloud Platforms

* ✅ Alibaba Cloud _"Managed Kubernetes Cluster Service" (ACK)_
* ✅ Amazon Web Services _"Elastic Kubernetes Engine" (EKS)_
* ✅ Digital Ocean _"Kubernetes" (DOK)_
* ✅ Google Cloud Platform _"Google Kubernetes Engine" (GKE)_
* ✅ Microsoft Azure _"Azure Kubernets Service" (AKS)_
* ✅ Oracle Cloud Infrastructure _"Container Engine for Kubernetes" (OKE)_
* 🔜 IBM Cloud _Kubernetes Service" (IKS)_ ([when their Terraform provider is 0.12-ready](https://github.com/IBM-Cloud/terraform-provider-ibm/pull/423))


- [Terraform Kubernetes Multi-Cloud](#Terraform-Kubernetes-Multi-Cloud)
    - [Features](#Features)
  - [Requirements](#Requirements)
  - [Terraform Inputs](#Terraform-Inputs)
  - [TODO](#TODO)


## Features

* Fully working K8s Clusters
* Terraform 0.12 code
* By default creates small node configurations (low costs!)
* Outputs ready-to-use kubeconfig files at the end
* 2-3 worker nodes


## Requirements

* Terraform >= 0.12.x

You need to have an account on the cloud platforms (of course).


## Terraform Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| enable_alibaba | Enable / Disable Alibaba | bool | false | yes |
| enable_amazon | Enable / Disable Amazon | bool | false | yes |
| enable_digitalocean | Enable / Disable DigitalOcean | bool | false | yes |
| enable_google | Enable / Disable Google | bool | false | yes |
| enable_microsoft | Enable / Disable Microsoft | bool | false | yes |
| enable_oracle | Enable / Disable Oracle | bool | false | yes |
| nodes | Kubernetes worker nodes (e.g. `2`) | number | 2 | no |
| ali_access_key | Alibaba Cloud AccessKey ID | string |  | yes |
| ali_secret_key | Alibaba Cloud Access Key Secret | string |  | yes |
| aws_profile | AWS cli profile (e.g. `default`) | string | default | yes |
| gcp_project | GCP Project ID | string |  | yes |
| az_client_id | Azure Service Principal appId | string |  | yes |
| az_client_secret | Azure Service Principal password | string |  | yes |
| az_tenant_id | Azure Service Principal tenant | string |  | yes |
| do_token | Digital Ocean personal access (API) token | string |  | yes |
| oci_user_ocid | OCI User OCID | string |  | yes |
| oci_tenancy_ocid | OCI Tenancy OCID | string |  | yes |
| oci_fingerprint | OCI SSH public key fingerprint | string |  | yes |


### TODO

* Combine multiple kubeconfig files into one
* _(partly implemented):_ Allow K8s API access only from workstation IP 
* Fix OCI destroy dependencies
