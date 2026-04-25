output "node_templates" {
  value = {
    for node_name, template in proxmox_virtual_environment_vm.node_template :
    node_name => {
      name  = template.name
      vm_id = template.vm_id
    }
  }
}

output "workers" {
  value = {
    for key, worker in proxmox_virtual_environment_vm.worker :
    key => {
      name      = worker.name
      node_name = worker.node_name
      vm_id     = worker.vm_id
    }
  }
}
