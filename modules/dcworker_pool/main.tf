locals {
  node_indexes = {
    for index, node_name in var.node_names : node_name => index
  }

  node_templates = {
    for node_name, index in local.node_indexes :
    node_name => {
      vm_id = var.node_template_vmid_start + index
      name  = "${var.template_name_prefix}-${node_name}"
    }
  }

  worker_maps = [
    for node_name in var.node_names : {
      for worker_index in range(max(lookup(var.workers_per_node, node_name, 0), 0)) :
      "${node_name}-${worker_index + 1}" => {
        node_name = node_name
        name      = "${var.worker_name_prefix}-${node_name}-${format("%02d", worker_index + 1)}"
        vm_id     = lookup(var.worker_vmid_start_by_node, node_name, -1) + worker_index
      }
    }
  ]

  workers = merge(local.worker_maps...)
}

resource "proxmox_virtual_environment_vm" "node_template" {
  for_each = local.node_templates

  name      = each.value.name
  node_name = each.key
  vm_id     = each.value.vm_id

  lifecycle {
    precondition {
      condition = alltrue([
        for node_name, worker_count in var.workers_per_node :
        contains(var.node_names, node_name) && worker_count >= 0
      ])
      error_message = "workers_per_node keys must exist in node_names, and worker counts must be greater than or equal to 0."
    }

    precondition {
      condition = alltrue([
        for node_name in var.node_names :
        contains(keys(var.worker_vmid_start_by_node), node_name)
      ])
      error_message = "worker_vmid_start_by_node must contain a starting VMID for every node in node_names."
    }
  }

  clone {
    vm_id        = var.source_template_vm_id
    node_name    = var.source_template_node_name
    datastore_id = var.datastore_id
    full         = true
  }

  agent {
    enabled = true
    timeout = "15m"
    trim    = true
  }

  cpu {
    cores   = var.cpu_cores
    sockets = var.cpu_sockets
    type    = var.cpu_type
  }

  memory {
    dedicated = var.memory_mb
    floating = var.memory_floating_mb
  }

  network_device {
    bridge   = var.bridge
    firewall = true
    model    = "virtio"
    vlan_id  = var.vlan_id
  }

  operating_system {
    type = "l26"
  }

  boot_order     = ["scsi0", "ide2", "net0"]
  on_boot        = false
  scsi_hardware  = "virtio-scsi-single"
  started        = false
  tags           = var.tags
  template       = true
  timeout_clone  = 1800
  timeout_create = 1800
}

resource "proxmox_virtual_environment_vm" "worker" {
  for_each = local.workers

  name      = each.value.name
  node_name = each.value.node_name
  vm_id     = each.value.vm_id

  clone {
    vm_id     = proxmox_virtual_environment_vm.node_template[each.value.node_name].vm_id
    node_name = each.value.node_name
    full      = false
  }

  agent {
    enabled = true
    timeout = "15m"
    trim    = true
  }

  cpu {
    cores   = var.cpu_cores
    sockets = var.cpu_sockets
    type    = var.cpu_type
  }

  memory {
    dedicated = var.memory_mb
    floating = var.memory_floating_mb
  }

  network_device {
    bridge   = var.bridge
    firewall = true
    model    = "virtio"
    vlan_id  = var.vlan_id
  }

  operating_system {
    type = "l26"
  }

  initialization {
    datastore_id = var.datastore_id
    interface    = "ide0"

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    dynamic "user_account" {
      for_each = var.user_account == null ? [] : [var.user_account]

      content {
        keys     = user_account.value.keys
        username = user_account.value.username
      }
    }
  }

  boot_order     = ["scsi0", "ide2", "net0"]
  on_boot        = true
  scsi_hardware  = "virtio-scsi-single"
  started        = true
  tags           = var.tags
  template       = false
  timeout_clone  = 1800
  timeout_create = 1800
}
