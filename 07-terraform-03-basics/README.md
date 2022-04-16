# 7.3. Основы и принцип работы Терраформ
## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws. 

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя,
а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано 
[здесь](https://www.terraform.io/docs/backends/types/s3.html).
1. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше. 

### Ответ:

1. Создан бакет в облаке Яндекса
2. Бэкенд настроен по [практическому руководству](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-state-storage#set-up-backend).

```bash
root@DESKTOP-S3C1B72:~/terraform-yc# terraform init -reconfigure

Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Reusing previous version of terraform-registry.storage.yandexcloud.net/hashicorp/local from the dependency lock file
- Reusing previous version of terraform-registry.storage.yandexcloud.net/yandex-cloud/yandex from the dependency lock file
- Reusing previous version of terraform-registry.storage.yandexcloud.net/hashicorp/null from the dependency lock file
- Using previously-installed terraform-registry.storage.yandexcloud.net/hashicorp/null v3.1.1
- Using previously-installed terraform-registry.storage.yandexcloud.net/hashicorp/local v2.2.2
- Using previously-installed terraform-registry.storage.yandexcloud.net/yandex-cloud/yandex v0.72.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

```

## Задача 2. Инициализируем проект и создаем воркспейсы. 

1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице 
dynamodb.
    * иначе будет создан локальный файл со стейтами.  
1. Создайте два воркспейса `stage` и `prod`.
1. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах 
использовались разные `instance_type`.
1. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два. 
1. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
1. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.
1. При желании поэкспериментируйте с другими параметрами и рессурсами.

В виде результата работы пришлите:
* Вывод команды `terraform workspace list`.
* Вывод команды `terraform plan` для воркспейса `prod`

### Ответ:

- создание воркспейсов:

```bash
root@DESKTOP-S3C1B72:~/terraform-yc# terraform workspace new stage
Created and switched to workspace "stage"!

You re now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
root@DESKTOP-S3C1B72:~/terraform-yc# terraform workspace new prod
Created and switched to workspace "prod"!

You r now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.

```

`terraform workspace list`:
```bash
root@DESKTOP-S3C1B72:~/terraform-yc# terraform workspace list
  default
* prod
  stage
```

`terraform plan` для воркспейса `prod`:
```bash
kad@g-deb-test:~/studing/devops-netology/terraform/07-terraform-03-basic$ terraform plan

root@DESKTOP-S3C1B72:~/terraform-yc# terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.vm-id[0] will be created
  + resource "yandex_compute_instance" "vm-id" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "netology-tf-0-prod.local"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5fRt8IXa1R2SgCoAv8ZIKuN76pjg5/wNILyNWhtciwiJ2I2t0XHkBoF3CUnIGded9C/FCfh30BkORo/jdhsl0SiCxIu7noCoLhlLmjYrrvne2UedVG6it63OABGRqAlDgmklkcWMvEavDFfS2/qz1fVN3t4Ib6gnu0KrU+kX8g4UaPjeQKgvoXWdgasnazBROFbI/jX3kVA8wNjpVo0qHD/XOeNfY3o2aiHwSVTnYi2VJrigLWSdlbKTagsuOTZRo7OMd5NYfO6uRBnzVbSrD4eZlkxMDVjP17BWq9j5Bjtg05zZmby8ld9iLdfjX3yMEAQElABFrUTVjO0jk3VoMT3e/uG5SF9wClFPUesquXpMPrjBVcLlIDDWmBFgvdR77nWUb7JPIXzsJuJHnXx8zv3xs6LImTfj1aEPSt/ob5/6O19QF0zVmOHf3FUCVSyAOApd/YcEyWU/ukaUbDyCwcMxkxv1ipYjjWJBzgvzkE5jbEehkYOTdPGo7Xl1oMG8= root@DESKTOP-S3C1B72
            EOT
        }
      + name                      = "vm-ubuntu-0-prod"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd86cpunl4kkspv0u25a"
              + name        = (known after apply)
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = false
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + placement_group_id = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-id[1] will be created
  + resource "yandex_compute_instance" "vm-id" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "netology-tf-1-prod.local"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5fRt8IXa1R2SgCoAv8ZIKuN76pjg5/wNILyNWhtciwiJ2I2t0XHkBoF3CUnIGded9C/FCfh30BkORo/jdhsl0SiCxIu7noCoLhlLmjYrrvne2UedVG6it63OABGRqAlDgmklkcWMvEavDFfS2/qz1fVN3t4Ib6gnu0KrU+kX8g4UaPjeQKgvoXWdgasnazBROFbI/jX3kVA8wNjpVo0qHD/XOeNfY3o2aiHwSVTnYi2VJrigLWSdlbKTagsuOTZRo7OMd5NYfO6uRBnzVbSrD4eZlkxMDVjP17BWq9j5Bjtg05zZmby8ld9iLdfjX3yMEAQElABFrUTVjO0jk3VoMT3e/uG5SF9wClFPUesquXpMPrjBVcLlIDDWmBFgvdR77nWUb7JPIXzsJuJHnXx8zv3xs6LImTfj1aEPSt/ob5/6O19QF0zVmOHf3FUCVSyAOApd/YcEyWU/ukaUbDyCwcMxkxv1ipYjjWJBzgvzkE5jbEehkYOTdPGo7Xl1oMG8= root@DESKTOP-S3C1B72
            EOT
        }
      + name                      = "vm-ubuntu-1-prod"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd86cpunl4kkspv0u25a"
              + name        = (known after apply)
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = false
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + placement_group_id = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-id2["vm-0"] will be created
  + resource "yandex_compute_instance" "vm-id2" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "vm-0.local"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5fRt8IXa1R2SgCoAv8ZIKuN76pjg5/wNILyNWhtciwiJ2I2t0XHkBoF3CUnIGded9C/FCfh30BkORo/jdhsl0SiCxIu7noCoLhlLmjYrrvne2UedVG6it63OABGRqAlDgmklkcWMvEavDFfS2/qz1fVN3t4Ib6gnu0KrU+kX8g4UaPjeQKgvoXWdgasnazBROFbI/jX3kVA8wNjpVo0qHD/XOeNfY3o2aiHwSVTnYi2VJrigLWSdlbKTagsuOTZRo7OMd5NYfO6uRBnzVbSrD4eZlkxMDVjP17BWq9j5Bjtg05zZmby8ld9iLdfjX3yMEAQElABFrUTVjO0jk3VoMT3e/uG5SF9wClFPUesquXpMPrjBVcLlIDDWmBFgvdR77nWUb7JPIXzsJuJHnXx8zv3xs6LImTfj1aEPSt/ob5/6O19QF0zVmOHf3FUCVSyAOApd/YcEyWU/ukaUbDyCwcMxkxv1ipYjjWJBzgvzkE5jbEehkYOTdPGo7Xl1oMG8= root@DESKTOP-S3C1B72
            EOT
        }
      + name                      = "vm-0"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd86cpunl4kkspv0u25a"
              + name        = (known after apply)
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = false
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + placement_group_id = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-id2["vm-1"] will be created
  + resource "yandex_compute_instance" "vm-id2" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "vm-1.local"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5fRt8IXa1R2SgCoAv8ZIKuN76pjg5/wNILyNWhtciwiJ2I2t0XHkBoF3CUnIGded9C/FCfh30BkORo/jdhsl0SiCxIu7noCoLhlLmjYrrvne2UedVG6it63OABGRqAlDgmklkcWMvEavDFfS2/qz1fVN3t4Ib6gnu0KrU+kX8g4UaPjeQKgvoXWdgasnazBROFbI/jX3kVA8wNjpVo0qHD/XOeNfY3o2aiHwSVTnYi2VJrigLWSdlbKTagsuOTZRo7OMd5NYfO6uRBnzVbSrD4eZlkxMDVjP17BWq9j5Bjtg05zZmby8ld9iLdfjX3yMEAQElABFrUTVjO0jk3VoMT3e/uG5SF9wClFPUesquXpMPrjBVcLlIDDWmBFgvdR77nWUb7JPIXzsJuJHnXx8zv3xs6LImTfj1aEPSt/ob5/6O19QF0zVmOHf3FUCVSyAOApd/YcEyWU/ukaUbDyCwcMxkxv1ipYjjWJBzgvzkE5jbEehkYOTdPGo7Xl1oMG8= root@DESKTOP-S3C1B72
            EOT
        }
      + name                      = "vm-1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd86cpunl4kkspv0u25a"
              + name        = (known after apply)
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = false
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + placement_group_id = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.net will be created
  + resource "yandex_vpc_network" "net" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "net"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet will be created
  + resource "yandex_vpc_subnet" "subnet" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.2.0.0/16",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 6 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + vm_public_ip      = [
      + (known after apply),
      + (known after apply),
    ]
  + yandex_private_ip = [
      + (known after apply),
      + (known after apply),
    ]
  + yandex_zone       = [
      + (known after apply),
      + (known after apply),
    ]
```
Конфигурации доступны по [ссылке]().

Отработка бэкэнда:
![img.png](img.png)