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

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

module "docker" {
  source            = "./modules/docker"
  public_key_path   = var.public_key_path
  private_key_path  = var.private_key_path
  docker_disk_image = var.docker_disk_image
  subnet_id         = var.subnet_id
  docker_count      = 2
}
