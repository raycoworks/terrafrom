provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

# Data sources to gather information
data "vsphere_datacenter" "datacenter" {
  name = var.datacenter_name
}

data "vsphere_host" "host" {
  name          = var.esxi_hostname
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "datastores" {
  count         = length(data.vsphere_host.host.datastore_ids)
  datacenter_id = data.vsphere_datacenter.datacenter.id
  id            = data.vsphere_host.host.datastore_ids[count.index]
}

data "vsphere_network" "networks" {
  count         = length(data.vsphere_host.host.network_ids)
  datacenter_id = data.vsphere_datacenter.datacenter.id
  id            = data.vsphere_host.host.network_ids[count.index]
}

data "vsphere_resource_pool" "resource_pools" {
  count         = length(data.vsphere_host.host.resource_pool_ids)
  id            = data.vsphere_host.host.resource_pool_ids[count.index]
}

# Output ESXi host information
output "esxi_host_info" {
