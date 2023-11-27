output "external_ip_address_docker" {
  value = [for ip in yandex_compute_instance.docker.*.network_interface.0.nat_ip_address : ip]
}
