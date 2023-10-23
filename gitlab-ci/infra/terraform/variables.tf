variable "cloud_id" {
  description = "The ID of the cloud"
}
variable "folder_id" {
  description = "The ID of the folder that the resource belongs to"
}
variable "zone" {
  description = "The availability zone"
  default     = "ru-central1-a"
}
variable "image_id" {
  description = "A disk image to initialize this disk from"
}
variable "subnet_id" {
  description = "ID of the subnet to attach this interface to"
}
variable "service_account_key_file" {
  description = "Path to key.json"
}
variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}
variable "private_key_path" {
  description = "Path to SSH private key file"
}
