output "external_ip_address_k8s" {
  value = [for ip in yandex_compute_instance.k8s.*.network_interface.0.nat_ip_address : ip]
}
