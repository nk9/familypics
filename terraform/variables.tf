variable "tenancy_ocid" {
}

variable "user_ocid" {
  default = ""
}

variable "fingerprint" {
}

variable "private_key" {
  default = ""
}

variable "ssh_public_key" {
  default = ""
}

variable "compartment_ocid" {
  description = "OCID for the root compartment"
}

variable "region" {
}

variable "hostname" {
  default = "familypics"
}

variable "host_domain" {
  default = "familypics.kocharhook.com"
}
