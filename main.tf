## Google Cloud Platform GKE

resource "google_container_cluster" "primary" {
  count    = var.enable_google ? 1 : 0
  name     = var.gke_name
  location = var.gcp_region
  project  = var.gcp_project

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  node_config {
    service_account = var.gke_serviceaccount
  }


  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username = ""
    password = ""
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  count      = var.enable_google ? 1 : 0
  project    = var.gcp_project
  name       = var.gke_pool_name
  location   = var.gcp_region
  cluster    = google_container_cluster.primary.0.name
  node_count = var.nodes





  node_config {
    preemptible     = true
    machine_type    = var.gke_node_type
    service_account = var.gke_serviceaccount

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      Project = "K8s"
    }

    tags = ["k8s"]
  }
}

data "template_file" "kubeconfig" {
  count    = var.enable_google ? 1 : 0
  template = "${file("${path.module}/gke_kubeconfig-template.yaml")}"

  vars = {
    oci_cluster_name = google_container_cluster.primary.0.name
    user_name        = google_container_cluster.primary.0.master_auth.0.username
    user_password    = google_container_cluster.primary.0.master_auth.0.password
    endpoint         = google_container_cluster.primary.0.endpoint
    cluster_ca       = google_container_cluster.primary.0.master_auth.0.cluster_ca_certificate
    client_cert      = google_container_cluster.primary.0.master_auth.0.client_certificate
    client_cert_key  = google_container_cluster.primary.0.master_auth.0.client_key
  }
}

resource "local_file" "kubeconfiggke" {
  count    = var.enable_google ? 1 : 0
  content  = "${data.template_file.kubeconfig.0.rendered}"
  filename = "${path.module}/kubeconfig_gke"
}


## Azure AKS

resource "azurerm_resource_group" "test" {
  count    = var.enable_microsoft ? 1 : 0
  name     = "K8sRG1"
  location = var.aks_region
}

resource "azurerm_kubernetes_cluster" "test" {
  count               = var.enable_microsoft ? 1 : 0
  name                = var.aks_name
  location            = azurerm_resource_group.test.0.location
  resource_group_name = azurerm_resource_group.test.0.name
  dns_prefix          = "k8s1"

  agent_pool_profile {
    name            = var.aks_agent_pool_name
    count           = var.nodes
    vm_size         = var.aks_node_type
    os_type         = "Linux"
    os_disk_size_gb = var.aks_node_disk_size
  }

  service_principal {
    client_id     = var.az_client_id
    client_secret = var.az_client_secret
  }

  tags = {
    Project = "k8s"
  }
}

resource "local_file" "kubeconfigaks" {
  count    = var.enable_microsoft ? 1 : 0
  content  = azurerm_kubernetes_cluster.test.0.kube_config_raw
  filename = "${path.module}/kubeconfig_aks"
}


## Digital Ocean Kubernetes (GA)

resource "digitalocean_kubernetes_cluster" "foo" {
  count   = var.enable_digitalocean ? 1 : 0
  name    = var.do_k8s_name
  region  = var.do_region
  version = var.do_k8s_version

  node_pool {
    name       = var.do_k8s_pool_name
    size       = var.do_k8s_node_type
    node_count = var.nodes
  }
}

resource "local_file" "kubeconfigdo" {
  count    = var.enable_digitalocean ? 1 : 0
  content  = digitalocean_kubernetes_cluster.foo.0.kube_config[0].raw_config
  filename = "${path.module}/kubeconfig_do"
}


## Amazon Web Services EKS

## Get your external IPv4 address:

data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  workstation-external-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"
}

# This data sources are included for ease of sample architecture deployment
# and can be swapped out as necessary.
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

# VPC
resource "aws_vpc" "demo" {
  cidr_block = var.cidr_block

  tags = "${
    map(
      "Name", "terraform-eks-demo-node",
      "kubernetes.io/cluster/${var.aws_cluster_name}", "shared",
    )
  }"
}

resource "aws_subnet" "demo" {
  count = var.enable_amazon ? var.subnets : 0

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index)
  vpc_id            = aws_vpc.demo.id

  tags = "${
    map(
      "Name", "terraform-eks",
      "kubernetes.io/cluster/${var.aws_cluster_name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "demo" {
  count = var.enable_amazon ? 1 : 0

  vpc_id = aws_vpc.demo.id

  tags = {
    Name = "terraform-eks"
  }
}

resource "aws_route_table" "demo" {
  count = var.enable_amazon ? 1 : 0

  vpc_id = aws_vpc.demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo.0.id
  }
}

resource "aws_route_table_association" "demo" {
  count = var.enable_amazon ? var.subnets : 0

  subnet_id      = aws_subnet.demo.*.id[count.index]
  route_table_id = aws_route_table.demo.0.id
}


# Master IAM
resource "aws_iam_role" "demo-cluster" {
  count = var.enable_amazon ? 1 : 0
  name  = "terraform-eks"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "demo-cluster-AmazonEKSClusterPolicy" {
  count = var.enable_amazon ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.demo-cluster.0.name
}

resource "aws_iam_role_policy_attachment" "demo-cluster-AmazonEKSServicePolicy" {
  count = var.enable_amazon ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role = aws_iam_role.demo-cluster.0.name
}


# Master Security Group
resource "aws_security_group" "demo-cluster" {
  count = var.enable_amazon ? 1 : 0

  name = "terraform-eks"
  description = "Cluster communication with worker nodes"
  vpc_id = aws_vpc.demo.id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks"
  }
}

# OPTIONAL: Allow inbound traffic from your local workstation external IP
#           to the Kubernetes. See data section at the beginning of the
#           AWS section.
resource "aws_security_group_rule" "demo-cluster-ingress-workstation-https" {
  count = var.enable_amazon ? 1 : 0

  cidr_blocks = ["${local.workstation-external-cidr}"]
  description = "Allow workstation to communicate with the cluster API Server"
  from_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.demo-cluster.0.id
  to_port = 443
  type = "ingress"
}


# EKS Master

resource "aws_eks_cluster" "demo" {
  count = var.enable_amazon ? 1 : 0

  name = var.aws_cluster_name
  role_arn = aws_iam_role.demo-cluster.0.arn

  vpc_config {
    security_group_ids = ["${aws_security_group.demo-cluster.0.id}"]
    subnet_ids = ["${aws_subnet.demo.0.id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.demo-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.demo-cluster-AmazonEKSServicePolicy",
  ]
}


# EKS Worker IAM

resource "aws_iam_role" "demo-node" {
  count = var.enable_amazon ? 1 : 0

  name = "terraform-eks-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "demo-node-AmazonEKSWorkerNodePolicy" {
  count      = var.enable_amazon ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.demo-node.0.name
}

resource "aws_iam_role_policy_attachment" "demo-node-AmazonEKS_CNI_Policy" {
  count      = var.enable_amazon ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.demo-node.0.name
}

resource "aws_iam_role_policy_attachment" "demo-node-AmazonEC2ContainerRegistryReadOnly" {
  count      = var.enable_amazon ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.demo-node.0.name
}

resource "aws_iam_instance_profile" "demo-node" {
  count = var.enable_amazon ? 1 : 0
  name  = "terraform-eks"
  role  = aws_iam_role.demo-node.0.name
}


# EKS Worker Security Groups

resource "aws_security_group" "demo-node" {
  count       = var.enable_amazon ? 1 : 0
  name        = "terraform-eks-node"
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.demo.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "terraform-eks-node",
     "kubernetes.io/cluster/${var.aws_cluster_name}", "owned",
    )
  }"
}

resource "aws_security_group_rule" "demo-node-ingress-self" {
  count                    = var.enable_amazon ? 1 : 0
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.demo-node.0.id
  source_security_group_id = aws_security_group.demo-node.0.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "demo-node-ingress-cluster" {
  count                    = var.enable_amazon ? 1 : 0
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.demo-node.0.id
  source_security_group_id = aws_security_group.demo-cluster.0.id
  to_port                  = 65535
  type                     = "ingress"
}


# EKS Master <--> Worker Security Group
resource "aws_security_group_rule" "demo-cluster-ingress-node-https" {
  count                    = var.enable_amazon ? 1 : 0
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.demo-cluster.0.id
  source_security_group_id = aws_security_group.demo-node.0.id
  to_port                  = 443
  type                     = "ingress"
}


# EKS Worker Nodes AutoScalingGroup
data "aws_ami" "eks-worker" {
  count = var.enable_amazon ? 1 : 0
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.demo.0.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}



# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We implement a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  demo-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.demo.0.endpoint}' --b64-cluster-ca '${aws_eks_cluster.demo.0.certificate_authority.0.data}' '${var.aws_cluster_name}'
USERDATA
}

resource "aws_launch_configuration" "demo" {
  count = var.enable_amazon ? 1 : 0
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.demo-node.0.name
  image_id = data.aws_ami.eks-worker.0.id
  instance_type = var.aws_instance_type
  name_prefix = "terraform-eks"
  security_groups = ["${aws_security_group.demo-node.0.id}"]
  user_data_base64 = "${base64encode(local.demo-node-userdata)}"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "demo" {
  count = var.enable_amazon ? 1 : 0
  desired_capacity = var.nodes
  launch_configuration = aws_launch_configuration.demo.0.id
  max_size = var.nodes
  min_size = 1
  name = "terraform-eks"
  vpc_zone_identifier = ["${aws_subnet.demo.0.id}"]

  tag {
    key = "Name"
    value = "terraform-eks"
    propagate_at_launch = true
  }

  tag {
    key = "kubernetes.io/cluster/${var.aws_cluster_name}"
    value = "owned"
    propagate_at_launch = true
  }
}


# EKS Join Worker Nodes
# EKS kubeconf

locals {
  count = var.enable_amazon ? 1 : 0
  config_map_aws_auth = <<CONFIGMAPAWSAUTH


apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.demo-node.0.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH

  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.demo.0.endpoint}
    certificate-authority-data: ${aws_eks_cluster.demo.0.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.aws_cluster_name}"
KUBECONFIG
}


resource "local_file" "kubeconfigaws" {
  count = var.enable_google ? 1 : 0
  content = local.config_map_aws_auth
  filename = "${path.module}/kubeconfig_aws"
}

resource "local_file" "eks_config_map_aws_auth" {
  count = var.enable_google ? 1 : 0
  content = local.config_map_aws_auth
  filename = "${path.module}/aws_config_map_aws_auth"
}

resource "null_resource" "apply_kube_configmap" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/aws_config_map_aws_auth"
  }

  depends_on = [aws_eks_cluster.demo]
}


# Alicloud Managed Kubernetes Service

####

## alicloud provider not yet compatible with Terraform 0.12 !
## https://github.com/terraform-providers/terraform-provider-alicloud/issues/1188

# ####

# data "alicloud_zones" main {
#   available_resource_creation = "VSwitch"
# }

# data "alicloud_instance_types" "default" {
#     availability_zone = "${data.alicloud_zones.main.zones.0.id}"
#     cpu_core_count = var.ali_node_type_cpu
#     memory_size = var.ali_node_type_memory
# }

# resource "random_string" "alipassword" {
#   length  = 24
#   special = false
# }


# resource "alicloud_cs_managed_kubernetes" "k8s" {
#   name = "${var.ali_name}"
#   availability_zone = "${data.alicloud_zones.main.zones.0.id}"
#   new_nat_gateway = true
#   worker_instance_types = ["${data.alicloud_instance_types.default.instance_types.0.id}"]
#   worker_numbers = var.ali_node_count
#   password = random_string.alipassword.result
#   pod_cidr = "172.20.0.0/16"
#   service_cidr = "172.21.0.0/20"
#   install_cloud_monitor = true
#   slb_internet_enabled = true
#   worker_disk_category  = "cloud_efficiency"
# }


## Oracle Cloud Infrastructure Container Service for Kubernetes

/**
 * Get the avaialbility domains for this tennancy.
 * Using any compartment id in this tennancy should also work just as well. 
 */
data "oci_identity_availability_domains" "ADs" {
  count = var.enable_oracle ? 1 : 0
  compartment_id = var.oci_tenancy_ocid
}


# Create random id
resource "random_id" "vnc_dns_randid" {
  count = var.enable_oracle ? 1 : 0
  byte_length = 1
}


# Identity Policy
resource "oci_identity_policy" "test_policy" {
  count = var.enable_oracle ? 1 : 0

  compartment_id = var.oci_tenancy_ocid
  description = var.oci_policy_description
  name = var.oci_policy_name
  statements = var.oci_policy_statements

  freeform_tags = { "Project" = "K8s" }
  #version_date = "${var.policy_version_date}"
}


# VCN
/*
 * Create a VCN. 
 * A DNS label with the name of the cluster is attached to the VCN.
 * The creation of the vcn also creates the default route table, security list, and dhcp options.
 */
resource "oci_core_vcn" "oke-vcn" {
  count = var.enable_oracle ? 1 : 0
  cidr_block = var.cidr_block
  compartment_id = var.oci_tenancy_ocid

  display_name = "${var.oci_cluster_name}_vcn"
  dns_label = "${var.oci_cluster_name}vcn${random_id.vnc_dns_randid.0.dec}"
  freeform_tags = { "Project" = "k8s" }
}


/*
 * An internet gateway is created in the relevant compartment attached to the created VCN. 
 */
resource "oci_core_internet_gateway" "oke-igateway" {
  count = var.enable_oracle ? 1 : 0
  compartment_id = var.oci_tenancy_ocid
  display_name = "${var.oci_cluster_name}-igateway"
  vcn_id = oci_core_vcn.oke-vcn.0.id
}


/*
 * Configures the default route table that was created when the VCN was created.
 * The default route is pointed to the internet gateway that was created. 
 */
resource "oci_core_default_route_table" "oke-default-route-table" {
  count = var.enable_oracle ? 1 : 0
  manage_default_resource_id = oci_core_vcn.oke-vcn.0.default_route_table_id
  display_name = "${var.oci_cluster_name}-default-route-table"

  route_rules {
    destination = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.oke-igateway.0.id}"
  }
}


/*
 * Configures the default dhcp options object that was created along with the VCN.
 */
resource "oci_core_default_dhcp_options" "oke-default-dhcp-options" {
  count = var.enable_oracle ? 1 : 0
  manage_default_resource_id = oci_core_vcn.oke-vcn.0.default_dhcp_options_id
  display_name = "${var.oci_cluster_name}-default-dhcp-options"

  options {
    type = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }
}


/*
 * Configures the default security list.
 */
resource "oci_core_default_security_list" "oke-default-security-list" {
  count = var.enable_oracle ? 1 : 0
  manage_default_resource_id = oci_core_vcn.oke-vcn.0.default_security_list_id
  display_name = "${var.oci_cluster_name}-default-security-list"

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol = "all"
  }

  // allow inbound ssh traffic
  ingress_security_rules {
    protocol = "6" // tcp
    source = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 22
      max = 22
    }
  }

  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol = 1
    source = "0.0.0.0/0"

    icmp_options {
      type = 3
      code = 4
    }
  }
}


/*
 * Security list for the worker subnets.
 *  - Stateless ingress/egress rule-pairs for the worker subnets. this lets traffic between the worker
 *    nodes flow freely. Stateless rule.
 *  - Contains a stateful rule to allow traffic to the internet - like for pulling docker images from 
 *    DockerHub
 *  - Conatins two ingress rules to allow SSH traffic from OCI Cluster service.
 */
resource "oci_core_security_list" "oke-worker-security-list" {
  count = var.enable_oracle ? var.subnets : 0
  compartment_id = var.oci_tenancy_ocid
  display_name = "${var.oci_cluster_name}-Workers-SecList"
  vcn_id = oci_core_vcn.oke-vcn.0.id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol = "6" // outbound TCP to the internet
    stateless = false
  }

  egress_security_rules {
    destination = cidrsubnet(var.cidr_block, 8, count.index)
    protocol = "all"
    stateless = true
  }

  ingress_security_rules {
    # Intra VCN traffic - this lets the 3 subnets in teh 3 ADs tak to each other without restriction.
    # These are stateless, so they need to be accompanied by stateless egress rules.
    stateless = true

    protocol = "all"
    source = cidrsubnet(var.cidr_block, 8, count.index)
  }

  ingress_security_rules {
    # ICMP 
    protocol = 1
    source = "0.0.0.0/0"

    icmp_options {
      type = 3
      code = 4
    }
  }
  ingress_security_rules {
    # OCI Cluster service
    protocol = "6" // tcp
    source = "130.35.0.0/16"
    stateless = false

    tcp_options {
      min = 22
      max = 22
    }
  }
  ingress_security_rules {
    protocol = "6" // tcp
    source = "138.1.0.0/17"
    stateless = false

    tcp_options {
      min = 22
      max = 22
    }
  }
  # NodePort ingress rules
  ingress_security_rules {
    protocol = "6" // tcp
    source = "0.0.0.0/0"
    stateless = true

    tcp_options {
      min = 30000
      max = 32767
    }
  }
  # SSH Stateful ingress rules
  ingress_security_rules {
    protocol = "6" // tcp
    source = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 22
      max = 22
    }
  }
}

/*
 * Security list for the loadbalancer subnets.
 * - Allows all TCP traffic in/out.
 */
resource "oci_core_security_list" "oke-lb-security-list" {
  count = var.enable_oracle ? 1 : 0
  compartment_id = var.oci_tenancy_ocid
  display_name = "${var.oci_cluster_name}-LoadBalancers-SecList"
  vcn_id = oci_core_vcn.oke-vcn.0.id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol = "6"
    stateless = true
  }
  ingress_security_rules {
    protocol = "6"
    source = "0.0.0.0/0"
    stateless = true
  }
}

/*
 * Create the subnets. 
 * A minimum of 4 Subnets are created. This is just a basic config.
 *
 * Worker Subnets
 * --------------
 * 2 Subnets (see var.subnets variable) are for worker nodes in the node pool.
 * The workers are spred across 3 availability  domains, and one subnet
 * is created for each AD to host workers in that AD. 
 * Obviously worker is a generic term, and assumes that the workload is homogeneous.
 * For more realistic topologies, you may need to create additional subnets and security rules to say,
 * separate parts of the application or certains components like a DB in to a separate subnet 
 * with separate security lists. You can for example create subnets to host frontend pods, 
 * middle tier pods as well as data store pods. You may want to restrict front ends to just have 
 * access to middle tier, but not DBs.  
 *
 * LB subnets
 * ----------
 * These two subnets host the LoadBalancers. If the K8s deployment create a service of type Loadbalancer
 * then an OCI loadbalancer is provisioned and this is placed in this subnet. The two subnet exists, because 
 * OCI loadbalancers can provide a floating VIP that can move over to the second availability domain 
 * in case the first one fails for some reason. Typical HA config.  
 *
 */
resource "oci_core_subnet" "oke-subnet-worker" {
  count = var.enable_oracle ? var.subnets : 0
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.0.availability_domains[0], "name")}"
  #cidr_block          = "${var.oci_vcn_cidr_prefix}.10.0/24"
  cidr_block = cidrsubnet(var.cidr_block, 8, count.index)
  display_name = "${var.oci_cluster_name}-WorkerSubnet${count.index}"
  dns_label = "workers${count.index}"
  compartment_id = var.oci_tenancy_ocid
  vcn_id = oci_core_vcn.oke-vcn.0.id
  security_list_ids = ["${oci_core_security_list.oke-worker-security-list.0.id}"]
  route_table_id = oci_core_vcn.oke-vcn.0.default_route_table_id
  dhcp_options_id = oci_core_vcn.oke-vcn.0.default_dhcp_options_id
}

resource "oci_core_subnet" "oke-subnet-loadbalancer" {
  count = var.enable_oracle ? 2 : 0
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.0.availability_domains[0], "name")}"
  #cidr_block          = "${var.oci_vcn_cidr_prefix}.20.0/24"
  cidr_block = cidrsubnet(var.cidr_block, 8, count.index)
  display_name = "${var.oci_cluster_name}-LB-Subnet${count.index}"
  dns_label = "lb${count.index}"
  compartment_id = var.oci_tenancy_ocid
  vcn_id = oci_core_vcn.oke-vcn.0.id
  security_list_ids = ["${oci_core_security_list.oke-lb-security-list.0.id}"]
  route_table_id = oci_core_vcn.oke-vcn.0.default_route_table_id
  dhcp_options_id = oci_core_vcn.oke-vcn.0.default_dhcp_options_id
}


# Container Engine for Kubernetes Cluster
resource "oci_containerengine_cluster" "test_cluster" {
  count = var.enable_oracle ? 1 : 0

  compartment_id = var.oci_tenancy_ocid
  kubernetes_version = var.oci_cluster_kubernetes_version
  name = var.oci_cluster_name
  vcn_id = oci_core_vcn.oke-vcn.0.id

  options {
    service_lb_subnet_ids = [
      for subnet in oci_core_subnet.oke-subnet-loadbalancer.*.id :
      subnet
    ]
    add_ons {
      is_kubernetes_dashboard_enabled = var.oci_cluster_options_add_ons_is_kubernetes_dashboard_enabled
      is_tiller_enabled = var.oci_cluster_options_add_ons_is_tiller_enabled
    }
  }
}


# Container Engine for Kubernetes Node Pool
resource "oci_containerengine_node_pool" "test_node_pool" {
  count = var.enable_oracle ? 1 : 0

  cluster_id = oci_containerengine_cluster.test_cluster.0.id
  compartment_id = var.oci_tenancy_ocid
  kubernetes_version = var.oci_cluster_kubernetes_version
  name = var.oci_node_pool_name
  node_image_name = var.oci_node_pool_node_image_name
  node_shape = var.oci_node_pool_node_shape
  subnet_ids = oci_core_subnet.oke-subnet-worker.*.id

  #Optional
  #node_image_name = "${var.node_pool_node_image_name}"
  #initial_node_labels {

  #Optional
  #key = "${var.node_pool_initial_node_labels_key}"
  #value = "${var.node_pool_initial_node_labels_value}"
  #}
  #node_metadata = "${var.oci_node_pool_node_metadata}"
  quantity_per_subnet = var.nodes
  #ssh_public_key = "${file(var.oci_node_pool_ssh_public_key)}"
}

data "oci_containerengine_cluster_kube_config" "tfsample_cluster_kube_config" {
  count = var.enable_oracle ? 1 : 0

  cluster_id = oci_containerengine_cluster.test_cluster.0.id
}

resource "local_file" "kubeconfigoci" {
  count = var.enable_oracle ? 1 : 0

  content = "${data.oci_containerengine_cluster_kube_config.tfsample_cluster_kube_config.0.content}"
  filename = "${path.module}/kubeconfig_oci"
}