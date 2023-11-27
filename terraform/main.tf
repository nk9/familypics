#
# Based on https://github.com/oracle/terraform-provider-oci/blob/master/examples/always_free/main.tf
#

terraform {
  cloud {
    organization = "nk9"

    workspaces {
      name = "familypics"
    }
  }
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 4.0.0"
    }
  }
}

provider "oci" {
  region       = var.region
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key
}

variable "instance_shape" {
  default = "VM.Standard.A1.Flex" # "VM.Standard.E2.1.Micro"
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}


# See https://docs.oracle.com/iaas/images/
data "oci_core_images" "test_images" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "9"
  shape                    = var.instance_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}


locals {
  compartment_id = oci_identity_compartment.familypics.compartment_id
}


output "app" {
  value = "http://${data.oci_core_vnic.app_vnic.public_ip_address}"
}
