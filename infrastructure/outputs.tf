output "subnet_ids" {
  value = [
    yandex_vpc_subnet.subnet-a.id,
    yandex_vpc_subnet.subnet-b.id,
    yandex_vpc_subnet.subnet-d.id
  ]
}

output "vpc_id" {
  value = yandex_vpc_network.main.id
}

output "security_group_id" {
  value = yandex_vpc_security_group.ssh.id
}
