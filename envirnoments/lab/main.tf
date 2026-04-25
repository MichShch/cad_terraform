module "dcworker_pool" {
  source = "../../modules/dcworker_pool"

  source_template_vm_id     = 131
  source_template_node_name = "pve1"

  node_names = ["pve1", "pve2", "pve3"]

  workers_per_node = {
    pve1 = 1
    pve2 = 1
    pve3 = 1
  }

  node_template_vmid_start = 3001
  worker_vmid_start        = 3100

  network_cidr  = "10.10.1.0/24"
  ip_start_host = 113
  gateway       = "10.10.1.1"

  datastore_id = "local-zfs"
  bridge       = "virt2"
}
