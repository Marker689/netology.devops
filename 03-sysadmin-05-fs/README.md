# Домашнее задание к занятию "3.5. Файловые системы"

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.

Ознакомился.

2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

Нет, так как hardlink это ссылка на тот же самый файл и имеет тот же inode.

4. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.


Настроено
```bash
vagrant@vagrant:~$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk
sdc                    8:32   0  2.5G  0 disk

```
5. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
```bash

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux

```
6. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.
```bash
root@vagrant:/home/vagrant# sfdisk -d /dev/sdb | sfdisk /dev/sdc --force
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x9b3cc1fc

Old situation:

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x9b3cc1fc.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0x9b3cc1fc

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```
7. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

```bash
root@vagrant:/home/vagrant# mdadm --create --verbose /dev/md1 -l 1 -n 2 /dev/sdb1
mdadm: You haven't given enough devices (real or missing) to create this array
root@vagrant:/home/vagrant# mdadm --create --verbose /dev/md1 -l 1 -n 2 /dev/sdb1 /dev/sdc1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 2094080K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
```

8. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

```bash
root@vagrant:/home/vagrant# mdadm --create --verbose /dev/md2 -l 0 -n 2 /dev/sdb2 /dev/sdc2
mdadm: chunk size defaults to 512K
mdadm: /dev/sdb2 appears to be part of a raid array:
       level=raid1 devices=2 ctime=Mon Dec 20 01:09:52 2021
mdadm: /dev/sdc2 appears to be part of a raid array:
       level=raid1 devices=2 ctime=Mon Dec 20 01:09:52 2021
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md2 started.



```

9. Создайте 2 независимых PV на получившихся md-устройствах.

```bash
root@vagrant:/home/vagrant# pvcreate /dev/md1 /dev/md2
  Physical volume "/dev/md1" successfully created.
  Physical volume "/dev/md2" successfully created.
root@vagrant:/home/vagrant#

```

10. Создайте общую volume-group на этих двух PV.

```bash
root@vagrant:/home/vagrant# vgcreate vg1 /dev/md1 /dev/md2
  Volume group "vg1" successfully created
root@vagrant:/home/vagrant# vgdisplay
  --- Volume group ---
  VG Name               vgvagrant
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  3
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                2
  Open LV               2
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <63.50 GiB
  PE Size               4.00 MiB
  Total PE              16255
  Alloc PE / Size       16255 / <63.50 GiB
  Free  PE / Size       0 / 0
  VG UUID               PaBfZ0-3I0c-iIdl-uXKt-JL4K-f4tT-kzfcyE

  --- Volume group ---
  VG Name               vg1
  System ID
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               <2.99 GiB
  PE Size               4.00 MiB
  Total PE              765
  Alloc PE / Size       0 / 0
  Free  PE / Size       765 / <2.99 GiB
  VG UUID               FC2O3F-yD7Q-4f0T-pQs6-yq4r-Hl6A-oo1owS
```

12. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
```bash
root@vagrant:/home/vagrant# lvcreate -L 100M vg1 /dev/md2
  Logical volume "lvol0" created.
root@vagrant:/home/vagrant# vgs
  VG        #PV #LV #SN Attr   VSize   VFree
  vg1         2   1   0 wz--n-  <2.99g 2.89g
  vgvagrant   1   2   0 wz--n- <63.50g    0
root@vagrant:/home/vagrant# lvs
  LV     VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lvol0  vg1       -wi-a----- 100.00m
  root   vgvagrant -wi-ao---- <62.54g
  swap_1 vgvagrant -wi-ao---- 980.00m
```

13. Создайте `mkfs.ext4` ФС на получившемся LV.

```bash
root@vagrant:/home/vagrant# mkfs.ext4 /dev/vg1/lvol0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```

14. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

```bash
root@vagrant:/home/vagrant# mkdir /tmp/new
root@vagrant:/home/vagrant# mount /dev/vg1/lvol0 /tmp/new/
```

15. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

```bash
root@vagrant:/home/vagrant# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2021-12-20 01:23:28--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22727355 (22M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz                                                   100%[===============================================================================================================================================================>]  21.67M  42.8MB/s    in 0.5s

2021-12-20 01:23:28 (42.8 MB/s) - ‘/tmp/new/test.gz’ saved [22727355/22727355]

```

16. Прикрепите вывод `lsblk`.

```bash
root@vagrant:/home/vagrant# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md1                9:1    0    2G  0 raid1
└─sdb2                 8:18   0  511M  0 part
  └─md2                9:2    0 1018M  0 raid0
    └─vg1-lvol0      253:2    0  100M  0 lvm   /tmp/new
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md1                9:1    0    2G  0 raid1
└─sdc2                 8:34   0  511M  0 part
  └─md2                9:2    0 1018M  0 raid0
    └─vg1-lvol0      253:2    0  100M  0 lvm   /tmp/new
```

18. Протестируйте целостность файла:

     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```
```bash
root@vagrant:/home/vagrant# gzip -t /tmp/new/test.gz
root@vagrant:/home/vagrant# echo $?
0
```

19. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
```bash
root@vagrant:/home/vagrant# pvmove /dev/md2
  /dev/md2: Moved: 32.00%
  /dev/md2: Moved: 100.00%

```
20. Сделайте `--fail` на устройство в вашем RAID1 md.

```bash
root@vagrant:/home/vagrant# mdadm /dev/md1 --fail /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md1
root@vagrant:/home/vagrant# mdadm -D /dev/md1
/dev/md1:
           Version : 1.2
     Creation Time : Mon Dec 20 01:09:07 2021
        Raid Level : raid1
        Array Size : 2094080 (2045.00 MiB 2144.34 MB)
     Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Mon Dec 20 01:29:32 2021
             State : active, degraded
    Active Devices : 1
   Working Devices : 1
    Failed Devices : 1
     Spare Devices : 0

Consistency Policy : resync

              Name : vagrant:1  (local to host vagrant)
              UUID : d178d48b:7050b890:f9b3789d:dcfcfa3a
            Events : 20

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1       8       33        1      active sync   /dev/sdc1

       0       8       17        -      faulty   /dev/sdb1
```

21. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.
```bash
root@vagrant:/home/vagrant# dmesg | grep md1
[  757.408421] md/raid1:md1: not clean -- starting background reconstruction
[  757.408423] md/raid1:md1: active with 2 out of 2 mirrors
[  757.408437] md1: detected capacity change from 0 to 2144337920
[  757.414329] md: resync of RAID array md1
[  767.930706] md: md1: resync done.
[ 1980.878620] md/raid1:md1: Disk failure on sdb1, disabling device.
               md/raid1:md1: Operation continuing on 1 devices.
```
22. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```
    
```bash
root@vagrant:/home/vagrant# gzip -t /tmp/new/test.gz
root@vagrant:/home/vagrant# echo $?
0
```

23. Погасите тестовый хост, `vagrant destroy`.

```bash
C:\Users\Marker\projects\vagrant-demo>vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...

C:\Users\Marker\projects\vagrant-demo>
```

---