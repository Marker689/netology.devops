terraform {
  required_providers {
    yandex = {
      source = "terraform-registry.storage.yandexcloud.net/yandex-cloud/yandex"
    }
    null = {
      source = "terraform-registry.storage.yandexcloud.net/hashicorp/null"
    }
    local = {
      source = "terraform-registry.storage.yandexcloud.net/hashicorp/local"
    }
  }
}