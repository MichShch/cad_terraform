module "dcworker_pool" {
  source = "../../modules/dcworker_pool"

  source_template_vm_id     = 3000
  source_template_node_name = "pve1"

  node_names = [
    "pve1",
    "pve2",
    "pve3",
    "pve4",
    "pve5",
    "pve6",
    "pve7",
    "pve8",
    "pve9",
    "pve10",
    "pve11",
  ]

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

  worker_vmid_start_by_node = {
    pve1  = 3100
    pve2  = 3200
    pve3  = 3300
    pve4  = 3400
    pve5  = 3500
    pve6  = 3600
    pve7  = 3700
    pve8  = 3800
    pve9  = 3900
    pve10 = 4000
    pve11 = 4100
  }

  datastore_id = "local-zfs"
  bridge       = "virt2"
}
