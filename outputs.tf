output "load_balancer_ip" {
  value = module.lb.load_balancer_ip
}

output "workers_ips" {
  value = module.network.workers_ips
}

output "master_ip" {
  value = module.network.master_ip
}