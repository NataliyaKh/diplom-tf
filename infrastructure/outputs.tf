# Outputs
output "nat_gateway_status" {
  value = {
    nat_gateway_id = yandex_vpc_gateway.nat_gateway.id
    route_table_id = yandex_vpc_route_table.nat_route.id
  }
}

output "instance_ips" {
  value = {
    master  = yandex_compute_instance.master.network_interface.0.nat_ip_address
    master_local = yandex_compute_instance.master.network_interface.0.ip_address
    worker1 = yandex_compute_instance.worker1.network_interface.0.nat_ip_address
    worker1_local = yandex_compute_instance.worker1.network_interface.0.ip_address
    worker2 = yandex_compute_instance.worker2.network_interface.0.nat_ip_address
    worker2_local = yandex_compute_instance.worker2.network_interface.0.ip_address
  }
}
