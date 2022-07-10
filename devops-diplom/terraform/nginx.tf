resource "yandex_compute_instance" "nginx" {
  name     = "nginx"
  hostname = "kharitonov.su"
  zone = "ru-central1-a"
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
    subnet_id      = resource.yandex_vpc_subnet.subnet-2.id
    nat            = true
    nat_ip_address = var.yc_reserved_ip
    ip_address = "10.8.2.254"
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
  scheduling_policy {
    preemptible = true
  }
}
