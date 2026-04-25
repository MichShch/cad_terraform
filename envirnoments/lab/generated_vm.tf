# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform
resource "proxmox_virtual_environment_vm" "DCBroker" {
  acpi                                 = true
  bios                                 = "seabios"
  boot_order                           = ["scsi0", "ide2", "net0"]
  delete_unreferenced_disks_on_destroy = true
  description                          = null
  hook_script_file_id                  = null
  keyboard_layout                      = null
  kvm_arguments                        = null
  mac_addresses                        = ["BC:24:11:C4:0B:80"]
  machine                              = null
  migrate                              = false
  name                                 = "DCBroker"
  network_device = [{
    bridge       = "virt2"
    disconnected = false
    enabled      = true
    firewall     = true
    mac_address  = "BC:24:11:C4:0B:80"
    model        = "virtio"
    mtu          = 0
    queues       = 0
    rate_limit   = 0
    trunks       = ""
    vlan_id      = 0
  }]
  node_name           = "pve1"
  on_boot             = true
  pool_id             = null
  protection          = false
  purge_on_destroy    = true
  reboot              = false
  reboot_after_update = true
  scsi_hardware       = "virtio-scsi-single"
  started             = true
  stop_on_destroy     = false
  tablet_device       = true
  tags                = []
  template            = false
  timeout_clone       = 1800
  timeout_create      = 1800
  timeout_migrate     = 1800
  timeout_reboot      = 1800
  timeout_shutdown_vm = 1800
  timeout_start_vm    = 1800
  timeout_stop_vm     = 300
  vm_id               = 107
  cpu {
    affinity     = null
    architecture = null
    cores        = 4
    flags        = []
    hotplugged   = 0
    limit        = 0
    numa         = false
    sockets      = 1
    type         = "host"
    units        = 0
  }
  disk {
    aio               = "io_uring"
    backup            = true
    cache             = "none"
    datastore_id      = "local-zfs"
    discard           = "ignore"
    file_format       = "raw"
    file_id           = null
    import_from       = null
    interface         = "scsi0"
    iothread          = true
    path_in_datastore = "vm-107-disk-0"
    replicate         = true
    serial            = null
    size              = 8
    ssd               = false
  }
  initialization {
    datastore_id = "local-zfs"
    interface    = "ide0"
    upgrade      = true
    ip_config {
      ipv4 {
        address = "10.10.1.100/24"
        gateway = "10.10.1.1"
      }
    }
    user_account {
      keys     = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGdcADXzxK4TBnpU5u83gKp6Domg5zZpKXVY6NE1WjqJj1GKa67WWruBIrl87RhozytVcSdbj97mSq7QcMwX/CaCKhvDUp+SyFHcN9I3iiCL+mMKe7YuhtEdwRYVyF/R0LUxTXV1B/bDnG1Hen4yidTEjwye9HFq3gxVQv801iTZUSo+XhY/fJWKz305GSe+MB+h+OvWa3n+fge8MOPjOMAO4GFQgaASVoIv0oAELYxIwolVBxCIouPthtdmKu/+jsd0TLZvXPgjo0wC4tbxwO250ukJ/S9aTtY/vw3vN9D0I4UafiUpgQduFlUTnrs5kJjs5dK1SzbXgVKfvCksK1T8K8+QF9zSSYNbgJn0jfvBRVItysJ29ELzh2KAopdm4l0azpJEmyxy+EEo2vDS6WP2EP88rzhG3wuNPI9sL6TACXGF9TtUWvvzwjJzRMYKoEVGxdQPG+Nk2zCuc7FesiZaAjKwfoolUNDJYDxHKUKW35OMRB/ka7zZ1cfwTep2DfJqBRTb00sIvwc3G4uthBvRCa9gs8zBO/wMtfslWEIlqYRvpy15x2v3m7+g0xYVfMuEKeuT8/RcxxToBTF/54k/U9oNEQVuObQmPBwOBced2Vf+4Qi0O7PPxKfY3/UwWi9wxfvIKy5VUcgetRRyif0/TGTQlc7SsjRAd/GvSv5w== root@pve3"]
      password = null # sensitive
      username = "apoj"
    }
  }
  memory {
    dedicated      = 2048
    floating       = 0
    hugepages      = null
    keep_hugepages = false
    shared         = 0
  }
  operating_system {
    type = "l26"
  }
  startup {
    down_delay = -1
    order      = 1
    up_delay   = -1
  }
}
