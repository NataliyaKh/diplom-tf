output "subnet_ids" {
  value = [
    yandex_vpc_subnet.subnet_a.id,
    yandex_vpc_subnet.subnet_b.id,
    yandex_vpc_subnet.subnet_d.id,
  ]
}

output "security_group_id" {
  value = yandex_vpc_security_group.ssh.id
}
