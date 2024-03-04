
# Ubuntu cloud images: https://cloud-images.ubuntu.com/jammy/current/
# Next resize it by: qemu-img resize /tmp/ubuntu.qcow2 10G
variable "img_path" {
  description = "ubuntu cloud image local path"
  default     = "/tmp/ubuntu.qcow2"
}

variable "domain" {
  default = "k8s.local"
}

variable "interface" {
  type = string
  default = "ens3"
}

variable "network_address" {
  type    = string
  default = "192.168.115.0/24"
}

variable "liczba_dyskow" {
  type    = number
  default = 6
}

variable "nodes" {
  type = map(object({
    name   = string
    memory = string
    vcpu   = number
    ip_addr = string
  }))
  default = {
    "imbir" = {
      name  = "k8s-imbir"
      memory = "2048"
      vcpu   = 2
      ip_addr = "192.168.115.21"
    },
    "czosnek" = {
      name   = "k8s-czosnek"
      memory = "2048"
      vcpu   = 2
      ip_addr = "192.168.115.22"
    },
    "cebula" = {
      name   = "k8s-cebula"
      memory = "2048"
      vcpu   = 2
      ip_addr = "192.168.115.23"
    },
  }
}
