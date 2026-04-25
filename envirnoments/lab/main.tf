module "vm_test_01" {
  source = "../../modules/vm"

  name         = "lab-vm-test-01"
  node_name    = "pve01"
  vm_id        = 201
  clone_vm_id  = 9000
  cpu_cores    = 2
  memory_mb    = 4096
  bridge       = "vmbr0"
  vlan_id      = 20
  datastore_id = "local-zfs"
}
