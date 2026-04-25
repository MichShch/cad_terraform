variable "source_template_vm_id" {
  type        = number
  description = "Existing source DCWorker template VM ID."
}

variable "source_template_node_name" {
  type        = string
  description = "Node where the existing source DCWorker template is located."
}

variable "node_names" {
  type        = list(string)
  description = "Target Proxmox nodes."
}

variable "workers_per_node" {
  type        = map(number)
  description = "Number of linked DCWorker clones to create on each target node."
}

variable "node_template_vmid_start" {
  type        = number
  description = "First VM ID for per-node full clone templates."
}

variable "worker_vmid_start" {
  type        = number
  description = "First VM ID for linked worker clones."
}

variable "network_cidr" {
  type        = string
  description = "IPv4 network CIDR used for worker addresses, for example 10.10.1.0/24."
}

variable "ip_start_host" {
  type        = number
  description = "First host number inside network_cidr for worker IP allocation."
}

variable "gateway" {
  type        = string
  description = "IPv4 gateway for worker cloud-init configuration."
}

variable "datastore_id" {
  type        = string
  default     = "local-zfs"
  description = "Target datastore for full template clones and cloud-init disks."
}

variable "bridge" {
  type        = string
  default     = "virt2"
  description = "Network bridge for DCWorker VMs."
}

variable "vlan_id" {
  type        = number
  default     = 0
  description = "VLAN ID for DCWorker network devices."
}

variable "template_name_prefix" {
  type        = string
  default     = "DCWorker-template"
  description = "Name prefix for per-node templates."
}

variable "worker_name_prefix" {
  type        = string
  default     = "DCWorker"
  description = "Name prefix for linked worker clones."
}

variable "cpu_cores" {
  type        = number
  default     = 4
  description = "CPU cores per socket."
}

variable "cpu_sockets" {
  type        = number
  default     = 2
  description = "CPU socket count."
}

variable "cpu_type" {
  type        = string
  default     = "x86-64-v2-AES"
  description = "Proxmox CPU type."
}

variable "memory_mb" {
  type        = number
  default     = 20480
  description = "Dedicated memory in MB."
}

variable "user_account" {
  type = object({
    username = string
    keys     = optional(list(string), [])
  })
  default     = null
  nullable    = true
  description = "Optional cloud-init user account override. Leave null to inherit it from the source template."
}

variable "tags" {
  type        = list(string)
  default     = ["distributed_computing", "quartus"]
  description = "Tags assigned to DCWorker resources."
}
