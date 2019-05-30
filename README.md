# Terraform Kubernetes Multi-Cloud

Terraform code for creating simple managed Kubernetes clusters on multiple public cloud platforms.

_Managed_ in this context means the master nodes are managed by the cloud platform provider. We only create the service, the worker nodes and the bare minimum of everything else to get a working K8s cluster.


This is for demonstration and/or learning purposes. 
**Please do not use this in production !**


## Public Cloud Platforms

* Amazon Web Services _"Elastic Kubernetes Engine" (EKS)_
* ✅ Digital Ocean _"Kubernetes"_
* ✅ Google Cloud Platform _"Google Kubernetes Engine" (GKE)_
* ✅ Microsoft Azure "_Azure Kubernets Service" (AKS)_
* **SOON:** Alibaba Cloud _"Managed Kubernetes Cluster Service"_


## Features

* By default creates only the minimum configuration neccessary
* 2 worker nodes
* 1 vCPU
* 2/3.75GB Memory
* Outputs kubeconfig files at the end


## Runtimes