terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  cloud_id  = "secret"
  folder_id = "secret"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "vm" {
  count = 3
  name  = "vm-${count.index + 1}"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd875m9ethhftod6n2vd"
      size     = 10
    }
  }

  network_interface {
    subnet_id = "e9bh35ikm13a85m5fg16"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}

output "external_ips" {
  value = yandex_compute_instance.vm[*].network_interface.0.nat_ip_address
}
