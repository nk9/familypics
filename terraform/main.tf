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

locals {
  compartment_id = oci_identity_compartment.familypics.compartment_id
}


data "oci_core_vnic_attachments" "app_vnics" {
  compartment_id      = local.compartment_id
  availability_domain = data.oci_identity_availability_domain.ad.name
  instance_id         = oci_core_instance.familypics2.id
}

data "oci_core_vnic" "app_vnic" {
  vnic_id = data.oci_core_vnic_attachments.app_vnics.vnic_attachments[0]["vnic_id"]
}

output "app" {
  description = "The public IP for the instance"
  value       = "http://${data.oci_core_vnic.app_vnic.public_ip_address}"
}
