variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}
variable "private_key_path" {
  description = "Path to SSH private key file"
}
variable "image_id" {
  description = "A disk image to initialize this disk from"
}
variable "disk_size" {
  description = "Disk size in GB"
  default     = 20
}
variable "subnet_id" {
  description = "ID of the subnet to attach this interface to"
}
variable "instances_count" {
  description = "Instances count"
  default     = 1
}
variable "cores" {
  description = "CPU cores for the instance"
  default     = 1
}
variable "memory" {
  description = "Memory size in GB"
  default     = 2
}
variable "core_fraction" {
  description = "Baseline performance for a core as a percent"
  default     = 20
}
variable "preemptible" {
  description = "Specifies if the instance is preemptible"
  default     = false
}
