# Commented - Crutches for non-working tests

# terraform {
#   required_version = "~> 1.5.1"
#   required_providers {
#     yandex = {
#       source  = "yandex-cloud/yandex"
#       version = "~> 0.95.0"
#     }
#   }
# }

resource "yandex_compute_instance" "docker" {
  count = var.docker_count
  name  = "reddit-docker-${count.index}"
  labels = {
    tags = "reddit-docker"
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.docker_disk_image
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
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
