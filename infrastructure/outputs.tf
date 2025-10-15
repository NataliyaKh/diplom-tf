output "subnet_ids" {
  value = [
    yandex_vpc_subnet.subnet_a.id,
    yandex_vpc_subnet.subnet_b.id,
    yandex_vpc_subnet.subnet_d.id,
  ]
}

output "security_group_id" {
  value = yandex_vpc_security_group.k8s.id
}

output "subnet_a_cidr" {
  value = yandex_vpc_subnet.subnet_a.v4_cidr_blocks[0]
}

output "subnet_b_cidr" {
  value = yandex_vpc_subnet.subnet_b.v4_cidr_blocks[0]
}

output "subnet_d_cidr" {
  value = yandex_vpc_subnet.subnet_d.v4_cidr_blocks[0]
}
