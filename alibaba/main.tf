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