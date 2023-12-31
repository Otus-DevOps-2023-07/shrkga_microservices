provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

module "docker" {
  source           = "./modules/docker"
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  image_id         = var.image_id
  subnet_id        = var.subnet_id
  instances_count  = 1
  cores            = 4
  memory           = 8
  core_fraction    = 50
  disk_size        = 50
  preemptible      = true
}
