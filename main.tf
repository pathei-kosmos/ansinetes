# Root wiring expresses the deployment graph through module outputs and resource IDs.
module "rg" {
  source                  = "./modules/rg"
  resource_group_location = var.resource_group_location
  resource_group_name     = var.resource_group_name

  tags = var.tags
}

module "network" {
  source                  = "./modules/network"
  resource_group_location = module.rg.resource_group_location
  resource_group_name     = module.rg.resource_group_name
  worker_count            = var.worker_count
  admin_cidr              = var.admin_cidr

  tags = var.tags
}

module "machines" {
  source                  = "./modules/machines"
  resource_group_location = module.rg.resource_group_location
  resource_group_name     = module.rg.resource_group_name
  jumpbox_nic_id          = module.network.jumpbox_nic_id
  worker_nic_ids          = module.network.worker_nic_ids
  vm_size                 = var.vm_size
  admin_username          = var.admin_username
  admin_ssh_public_key    = var.admin_ssh_public_key

  tags = var.tags
}

module "lb" {
  source                  = "./modules/lb"
  resource_group_location = module.rg.resource_group_location
  resource_group_name     = module.rg.resource_group_name
  worker_nic_ids          = module.network.worker_nic_ids

  tags = var.tags
}
