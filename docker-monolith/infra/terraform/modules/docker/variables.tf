variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}
variable "private_key_path" {
  description = "SSH private key"
}
variable "docker_disk_image" {
  description = "Disk image for reddit docker"
  default     = "reddit-docker"
}
variable "subnet_id" {
  description = "Subnets for modules"
}
variable "docker_count" {
  description = "Instances count"
  default     = 1
}
