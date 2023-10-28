resource "yandex_compute_instance" "docker" {
  count    = var.instances_count
  name     = "docker-${count.index}"
  hostname = "docker-${count.index}"
  labels = {
    tags = "docker"
  }
  platform_id = "standard-v3"
  resources {
    cores         = var.cores
    memory        = var.memory
    core_fraction = var.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.disk_size
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  metadata = {
    user-data = <<EOT
#cloud-config
users:
  - name: appuser
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - ${file(var.public_key_path)}
  - name: ubuntu
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - ${file(var.public_key_path)}
packages:
  - git
EOT
  }
}
