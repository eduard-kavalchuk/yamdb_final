terraform {
  required_version = "~> 1.3.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token              = var.token
  cloud_id           = var.cloud_id
  folder_id          = var.folder_id
  zone               = "ru-central1-a"
  storage_access_key = var.storage_access_key
  storage_secret_key = var.storage_secret_key
}

resource "yandex_vpc_network" "vpc_network" {
}

resource "yandex_vpc_subnet" "vpc_subnet" {
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc_network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_compute_instance" "ubuntu" {
  zone = yandex_vpc_subnet.vpc_subnet.zone

  resources {
    cores         = 2
    memory        = 6
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      type     = "network-hdd"
      size     = 20
      image_id = "fd8hvlnfb66dgavf0e1a"  # Ubuntu 18.04
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.vpc_subnet.id
    nat       = true
  }

  # Optional parameters
  service_account_id = var.service_account_id

  # Provide user data
  metadata = {
    serial-port-enable = "1"
    user-data          = file("${path.module}/userconfig.txt")
  }
}


# Variables

variable "token" {
  description = "Default yandex authorization token"
  type        = string
}

variable "cloud_id" {
  description = "Default clound ID in yandex cloud"
  type        = string
}

variable "folder_id" {
  description = "Default folder ID in yandex cloud"
  type        = string
}

variable "storage_access_key" {
  description = "Static key ID"
  type        = string
}

variable "storage_secret_key" {
  description = "Static key, secret part"
  type        = string
}

variable "service_account_id" {
  description = "Service account ID"
  type        = string
}

output "internal_ip_address" {
  value = yandex_compute_instance.ubuntu.network_interface[0].ip_address
}

output "external_ip_address" {
  value = yandex_compute_instance.ubuntu.network_interface[0].nat_ip_address
}
