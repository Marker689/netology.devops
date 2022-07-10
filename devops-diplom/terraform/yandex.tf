provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id                 = var.yc_cloud_id
  folder_id                = var.yc_folder_id
  zone                     = var.yc_region
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}


resource "yandex_vpc_network" "net" {
  name = "net"
  folder_id = var.yc_folder_id
}

resource "yandex_vpc_route_table" "nat-instance-route" {
  network_id = resource.yandex_vpc_network.net.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = resource.yandex_compute_instance.nginx.network_interface[0].ip_address
  }
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet-1"
  network_id     = resource.yandex_vpc_network.net.id
  v4_cidr_blocks = ["10.8.1.0/24"]
  zone           = "ru-central1-a"
  route_table_id = resource.yandex_vpc_route_table.nat-instance-route.id
}

resource "yandex_vpc_subnet" "subnet-2" {
  name           = "subnet-2"
  network_id     = resource.yandex_vpc_network.net.id
  v4_cidr_blocks = ["10.8.2.0/24"]
  zone           = "ru-central1-a"
}
