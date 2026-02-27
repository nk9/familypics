#
# VM instance
#

resource "oci_core_instance" "familypics2" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = local.compartment_id
  display_name        = "familypics2"
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_shape_config_memory_in_gbs
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.test_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = false
    hostname_label   = "familypics2"
  }

  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.ubuntu.images[0], "id")
  }

  metadata = {
    ssh_authorized_keys = (var.ssh_public_key != "") ? var.ssh_public_key : tls_private_key.compute_ssh_key.public_key_openssh
    user_data = base64encode(data.template_file.user_data.rendered)
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud-init.yaml")
  vars = {}
}


#
# Persistent Data Volume
#

resource "oci_core_volume" "data_volume" {
  availability_domain = oci_core_instance.familypics2.availability_domain
  compartment_id      = local.compartment_id
  display_name        = "app-data-volume"
  size_in_gbs         = 50  # free tier max total block storage = 200GB
}

resource "oci_core_volume_attachment" "data_volume_attachment" {
  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.familypics2.id
  volume_id       = oci_core_volume.data_volume.id
}


#
# Setup
#
variable "instance_shape" {
  default = "VM.Standard.A1.Flex" # "VM.Standard.E2.1.Micro"
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 3
}


# See https://docs.oracle.com/iaas/images/
data "oci_core_images" "ubuntu" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04"
  shape                    = var.instance_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "tls_private_key" "compute_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

variable "instance_ocpus" { default = 1 }

variable "instance_shape_config_memory_in_gbs" { default = 6 }



#
# Output
#
output "generated_private_key_pem" {
  value     = (var.ssh_public_key != "") ? var.ssh_public_key : tls_private_key.compute_ssh_key.private_key_pem
  sensitive = true
}
