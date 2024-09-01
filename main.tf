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

  tags = var.tags
}

module "machines" {
  source                  = "./modules/machines"
  resource_group_location = module.rg.resource_group_location
  resource_group_name     = module.rg.resource_group_name
  worker_count            = var.worker_count
  nic_master_id           = module.network.nic_master_id
  nic_workers             = module.network.nic_workers
  vm_size                 = var.vm_size
  vm_password             = var.vm_password

  tags = var.tags
}

module "lb" {
  source                  = "./modules/lb"
  resource_group_location = module.rg.resource_group_location
  resource_group_name     = module.rg.resource_group_name
  worker_count            = var.worker_count
  vnet_id                 = module.network.vnet_id
  nic_workers             = module.network.nic_workers

  tags = var.tags
}