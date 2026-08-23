output "load_balancer_ip" {
  description = "Public IPv4 address of the Standard Load Balancer HTTP frontend."
  value       = module.lb.load_balancer_ip
}

output "jumpbox_public_ip" {
  description = "Public IPv4 address used for restricted administrative SSH access."
  value       = module.network.jumpbox_public_ip
}

output "worker_private_ips" {
  description = "Private IPv4 addresses assigned to the nginx workers."
  value       = module.network.worker_private_ips
}

output "ansible_inventory" {
  description = "Secret-free Ansible inventory that connects to workers through the jumpbox."
  value       = <<-EOT
    [workers]
    ${join("\n", [for index, ip in module.network.worker_private_ips : "worker-${index} ansible_host=${ip}"])}

    [workers:vars]
    ansible_user=${var.admin_username}
    ansible_python_interpreter=/usr/bin/python3
    ansible_ssh_common_args='-o ProxyJump=${var.admin_username}@${module.network.jumpbox_public_ip} -o StrictHostKeyChecking=accept-new'
  EOT
}
