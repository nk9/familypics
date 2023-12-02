locals {
  tcp      = "6" # IANA protocol number
  cidr_all = "0.0.0.0/0"
}

resource "oci_core_virtual_network" "familypics" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = local.compartment_id
  display_name   = "familypicsVCN"
  dns_label      = "familypicsvcn"
}

resource "oci_core_subnet" "test_subnet" {
  cidr_block        = "10.1.20.0/24"
  display_name      = "testSubnet"
  dns_label         = "testsubnet"
  security_list_ids = [oci_core_security_list.test_security_list.id]
  compartment_id    = local.compartment_id
  vcn_id            = oci_core_virtual_network.familypics.id
  route_table_id    = oci_core_route_table.test_route_table.id
  dhcp_options_id   = oci_core_virtual_network.familypics.default_dhcp_options_id
}

resource "oci_core_internet_gateway" "test_internet_gateway" {
  compartment_id = local.compartment_id
  display_name   = "testIG"
  vcn_id         = oci_core_virtual_network.familypics.id
}

resource "oci_core_route_table" "test_route_table" {
  compartment_id = local.compartment_id
  vcn_id         = oci_core_virtual_network.familypics.id
  display_name   = "testRouteTable"

  route_rules {
    destination       = local.cidr_all
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.test_internet_gateway.id
  }
}

resource "oci_core_security_list" "test_security_list" {
  compartment_id = local.compartment_id
  vcn_id         = oci_core_virtual_network.familypics.id
  display_name   = "testSecurityList"

  egress_security_rules {
    protocol    = local.tcp
    destination = local.cidr_all
  }

  # SSH
  ingress_security_rules {
    protocol = local.tcp
    source   = local.cidr_all

    tcp_options {
      max = "22"
      min = "22"
    }
  }

  # HTTP
  ingress_security_rules {
    protocol = local.tcp
    source   = local.cidr_all

    tcp_options {
      max = "80"
      min = "80"
    }
  }

  # HTTPS
  ingress_security_rules {
    protocol = local.tcp
    source   = local.cidr_all

    tcp_options {
      max = "443"
      min = "443"
    }
  }
}
