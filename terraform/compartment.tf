resource "oci_identity_compartment" "familypics" {
  compartment_id = var.compartment_ocid # root compartment
  description    = "Compartment for family pictures."
  name           = "familypics"
}
