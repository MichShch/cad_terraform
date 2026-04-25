resource "proxmox_virtual_environment_vm" "this" {
  name      = var.name
  node_name = var.node_name
  vm_id     = var.vm_id

  clone {
    vm_id = var.clone_vm_id
  }

  cpu {
    cores = var.cpu_cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.memory_mb
  }

  network_device {
    bridge = var.bridge
    vlan_id = var.vlan_id
  }

  disk {
    datastore_id = var.datastore_id
    interface    = "scsi0"
    size         = 20
    iothread     = true
    discard      = "on"
  }

  agent {
    enabled = true
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  on_boot = true
  started = true
}