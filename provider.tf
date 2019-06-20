provider "google" {
  # set envvar GOOGLE_CLOUD_KEYFILE_JSON in clie before executing
  credentials = file("account.json")
  project     = var.gcp_project
  region      = var.gcp_region
}

# Configure the Azure Provider
# Set the following ENVVARs:
# ARM_CLIENT_ID
# ARM_TENANT_ID
# ARM_ENVIRONMENT
# (You can get them via `az account list`)
provider "azurerm" {

  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = ">=1.29"
}

# # Configure the Microsoft Azure Active Directory Provider
# provider "azuread" {
#   alias   = "azuread"
#   version = ">=0.3.0"
# }

#Configure the DigitalOcean Provider
provider "digitalocean" {
  alias = "digitalocean"
  token = var.do_token
}


## AWS

# Configure the AWS Provider
provider "aws" {
  version    = ">=2.14"
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_access_key
  profile    = var.aws_profile
}


## AliCloud

# Configure the Alicloud Provider
# provider "alicloud" {
#   version = ">=1.46.0"
#   access_key = "${var.ali_access_key}"
#   secret_key = "${var.ali_secret_key}"
#   region     = "${var.ali_region}"
# }


## Oracle Cloud Infrastructure
# Configure the Oracle Cloud Infrastructure provider with an API Key
provider "oci" {
  alias            = "oci"
  version          = ">=3.28"
  tenancy_ocid     = "${var.oci_tenancy_ocid}"
  user_ocid        = "${var.oci_user_ocid}"
  fingerprint      = "${var.oci_fingerprint}"
  private_key_path = "${var.oci_private_key_path}"
  public_key_path = "${var.oci_public_key_path}"
  region           = "${var.oci_region}"
}




