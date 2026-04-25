variable "name" {
  type = string
}

variable "node_name" {
  type = string
}

variable "vm_id" {
  type = number
}

variable "clone_vm_id" {
  type = number
}

variable "cpu_cores" {
  type    = number
  default = 2
}

variable "memory_mb" {
  type    = number
  default = 2048
}

variable "bridge" {
  type    = string
  default = "vmbr0"
}

variable "vlan_id" {
  type    = number
  default = null
}

variable "datastore_id" {
  type    = string
  default = "local-zfs"
}