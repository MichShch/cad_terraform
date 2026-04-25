module "dcworker_pool" {
  source = "../../modules/dcworker_pool"

  source_template_vm_id     = 3000
  source_template_node_name = "pve1"

  node_names = ["pve1", "pve2", "pve3", "pve4", "pve5", "pve6", "pve7", "pve8", "pve9", "pve10", "pve11"]

  workers_per_node = {
    pve1 = 1
    pve2 = 3
    pve3 = 1
    pve4 = 3
    pve5 = 3
    pve6 = 3
    pve7 = 3
    pve8 = 3
    pve9 = 3
    pve10 = 3
    pve11 = 3
  }

  node_template_vmid_start = 3001
  worker_vmid_start        = 3100

  network_cidr  = "10.10.1.0/24"
  ip_start_host = 120
  gateway       = "10.10.1.1"

  datastore_id = "local-zfs"
  bridge       = "virt2"
}
