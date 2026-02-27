#
# Static IP/VNIC
#
resource "oci_core_public_ip" "static_ip" {
  compartment_id = local.compartment_id
  lifetime       = "RESERVED"
  display_name   = "familypics-static-ip"
  private_ip_id = data.oci_core_private_ips.familypics2.private_ips[0].id
}

data "oci_core_vnic_attachments" "attachments" {
  compartment_id = local.compartment_id
  instance_id    = oci_core_instance.familypics2.id
}

data "oci_core_vnic" "primary_vnic" {
  vnic_id = data.oci_core_vnic_attachments.attachments.vnic_attachments[0].vnic_id
}

data "oci_core_private_ips" "familypics2" {
  vnic_id = data.oci_core_vnic_attachments.attachments.vnic_attachments[0].vnic_id
}
