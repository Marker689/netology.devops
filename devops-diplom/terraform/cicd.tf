resource "yandex_compute_instance" "gitlab" {
  name     = "gitlab"
  hostname = "gitlab.kharitonov.su"

  resources {
    cores  = 8
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 25
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
resource "yandex_compute_instance" "runner" {
  name     = "runner"
  hostname = "runner.kharitonov.su"

  resources {
    cores  = 2
    memory = 2
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
