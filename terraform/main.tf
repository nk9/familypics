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

output "app" {
  description = "The public IP for the instance"
  value       = "${oci_core_public_ip.static_ip.ip_address}"
}
