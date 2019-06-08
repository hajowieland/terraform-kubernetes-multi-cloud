# Terraform Kubernetes Multi-Cloud

Terraform code for creating a handful of simple managed Kubernetes clusters on multiple public cloud platforms.

_Managed_ in this context means the master nodes are managed by the cloud platform provider. We only create the service, the worker nodes and the bare minimum of everything else to get a working K8s cluster.


This is for demonstration and/or learning purposes. 
**Please do not use this in production !**


## Public Cloud Platforms

* ✅ Amazon Web Services _"Elastic Kubernetes Engine" (EKS)_
* ✅ Digital Ocean _"Kubernetes"_
* ✅ Google Cloud Platform _"Google Kubernetes Engine" (GKE)_
* ✅ Microsoft Azure _"Azure Kubernets Service" (AKS)_
* ✅ Oracle Cloud Infrastructure _"Container Engine for Kubernetes"_
* **SOON:** Alibaba Cloud _"Managed Kubernetes Cluster Service"_ (when its Terraform provider is 0.12-ready)


## Features

* By default creates only the minimum configuration neccessary
* 2 worker nodes
* 1 vCPU
* 2/3.75GB Memory
* Outputs kubeconfig files at the end


## Requirements

You need to have an account on the cloud platforms (of course).

Set this variables (e.g. in your local terraform.tfvars file):

```
gcp_project = "<gcp project id>"
gke_serviceaccount = "<gke serviceaccount to use"
# gcp_region = "<gcp region>"
do_token = "<digitalocean token"
# do_region = "<digitalocean region>"
az_client_id = "<azure appId>"
az_client_secret = "<azure password>"
az_tenant_id = "<azure tenant>"
# aks_region "<azure region>"
# ali_acccess_key = "<alicloud access_key>"
# ali_secret_key = "<alicloud secret_key>"
# ali_region = "<alicloud region>"
oci_tenancy_ocid = "<oci tenancy ocid>"
oci_user_ocid = "<oci user ocid>"
oci_fingerprint = "<oci ssh key fingerprint>"
# oci_region = "<oci region>"
```

### Azure

Create a Service Principal:

```
az login
az account list
az ad sp create-for-rbac --role="Contributor"
```

appId => client_id

password => client_secret

tenant => tenant_id


### Digital Ocean

Create a Token four your account.


### Google Cloud Platform

You need to have a Project and a Service account in it.



### Oracle Cloud Infrastructure

https://github.com/oracle/weblogic-kubernetes-operator/tree/master/kubernetes/samples/scripts/terraform


Create an OCI account at

Get your user OCI and Tenant OCI

Get your SSH key fingerprint:  `openssl rsa -pubout -outform DER -in ~/.oci/oci_api_key.pem | openssl md5 -c`


Install oci-cli and configure with `oci setup config` - fill in the details from above plus region to use.

Upload your Key to your account via the Console.

Now Terraform uses this OCI credentials. If you want to configure them manually in Terraform, just uncomment the specific provider details.


## Runtimes