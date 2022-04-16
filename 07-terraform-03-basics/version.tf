# req
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

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "netology-bucket"
    region     = "ru-central1"
    key        = "terraform.tfstate"
    access_key = "YCAJExaIOGCv9iPQmRK6SNc-L"
    secret_key = "********"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}