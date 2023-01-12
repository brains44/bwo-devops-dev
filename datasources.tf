## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

data "oci_containerengine_cluster_option" "oci_oke_cluster_option" {
  cluster_option_id = "all"
}

data "oci_containerengine_node_pool_option" "oci_oke_node_pool_option" {
  node_pool_option_id = "all"
}

data "oci_core_services" "AllOCIServices" {
  count = var.use_existing_vcn ? 0 : 1
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}

data "oci_identity_availability_domains" "AD" {
  compartment_id  = var.tenancy_ocid

  filter {
    name   = "name"
    values = ["${var.availability_domain}"]
  }
}


data "oci_containerengine_cluster_kube_config" "KubeConfig" {
  cluster_id    = oci_containerengine_cluster.oci_oke_cluster.id
  token_version = var.cluster_kube_config_token_version
}

# get latest Oracle Linux image based on tf
data "oci_core_images" "oraclelinux-bwo" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.image_operating_system
  operating_system_version = var.image_operating_system_version
  filter {
    name   = "display_name"
    values = ["^([a-zA-z]+)-([a-zA-z]+)-([\\.0-9]+)-([\\.0-9-]+)$"]
    regex  = true
  }
}

