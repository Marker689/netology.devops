resource "yandex_compute_instance" "db01" {
  name     = "db01"
  hostname = "db01.kharitonov.su"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 6
    }
  }

  network_interface {
    subnet_id      = yandex_vpc_subnet.subnet-1.id
    nat            = false
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "db02" {
  name     = "db02"
  hostname = "db02.kharitonov.su"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 6
    }
  }

  network_interface {
    subnet_id      = yandex_vpc_subnet.subnet-1.id
    nat            = false
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
  scheduling_policy {
    preemptible = true
  }
}
