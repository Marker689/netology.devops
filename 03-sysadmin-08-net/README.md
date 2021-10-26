# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```


```bash
route-views>sh ip route 46.188.43.238
Routing entry for 46.188.0.0/17
  Known via "bgp 6447", distance 20, metric 0
  Tag 6939, type external
  Last update from 64.71.137.241 16:24:29 ago
  Routing Descriptor Blocks:
  * 64.71.137.241, from 64.71.137.241, 16:24:29 ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 6939
      MPLS label: none
route-views>sh bgp 46.188.43.238
BGP routing table entry for 46.188.0.0/17, version 1838925115
Paths: (23 available, best #22, table default)
  Not advertised to any peer
  Refresh Epoch 1
  20912 3257 28917 39153 39153 8334
    212.66.96.126 from 212.66.96.126 (212.66.96.126)
      Origin incomplete, localpref 100, valid, external
      Community: 3257:4000 3257:8133 3257:50001 3257:50110 3257:54901 20912:65004
      path 7FE173AA00C8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3333 1257 28917 39153 39153 8334
    193.0.0.56 from 193.0.0.56 (193.0.0.56)
      Origin incomplete, localpref 100, valid, external
      Community: 1257:50 1257:51 1257:2000 1257:3428 1257:4103 28917:2000 28917:5310 28917:5320 39153:10 39153:509
      path 7FE1187ECD98 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  8283 28917 39153 39153 8334
    94.142.247.3 from 94.142.247.3 (94.142.247.3)
      Origin incomplete, metric 0, localpref 100, valid, external
      Community: 0:6939 0:16276 8283:1 8283:101 28917:2000 28917:5310 28917:5320 39153:10 39153:509
      unknown transitive attribute: flag 0xE0 type 0x20 length 0x18
        value 0000 205B 0000 0000 0000 0001 0000 205B
              0000 0005 0000 0001
      path 7FE176AE0E08 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3356 20764 20764 39153 39153 8334
    4.68.4.46 from 4.68.4.46 (4.69.184.201)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3356:2 3356:22 3356:100 3356:123 3356:501 3356:903 3356:2065 20764:1154 20764:1202 20764:1301 20764:1411 20764:1434 20764:1464 20764:1474 20764:1504 20764:1513 20764:1533 20764:1544 20764:1640 20764:1650 20764:1660 20764:1670 20764:3002 20764:3011 20
764:3021 39153:10 39153:504
      path 7FE0F960C768 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  53767 174 20764 20764 39153 39153 8334
    162.251.163.2 from 162.251.163.2 (162.251.162.3)
      Origin incomplete, localpref 100, valid, external
      Community: 174:21101 174:22014 53767:5000
      path 7FE0C1D65CA0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3549 3356 20764 20764 39153 39153 8334
    208.51.134.254 from 208.51.134.254 (67.16.168.191)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3356:2 3356:22 3356:100 3356:123 3356:501 3356:903 3356:2065 3549:2581 3549:30840 20764:1154 20764:1202 20764:1301 20764:1411 20764:1434 20764:1464 20764:1474 20764:1504 20764:1513 20764:1533 20764:1544 20764:1640 20764:1650 20764:1660 20764:1670 207
64:3002 20764:3011 20764:3021 39153:10 39153:504
      path 7FE15D57DBB8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  57866 28917 39153 39153 8334
    37.139.139.17 from 37.139.139.17 (37.139.139.17)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 0:6939 0:16276 28917:2000 28917:5310 28917:5320 39153:10 39153:509 57866:304 57866:501
      path 7FE14749BA80 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20130 6939 39153 8334
    140.192.8.16 from 140.192.8.16 (140.192.8.16)
      Origin IGP, localpref 100, valid, external
      path 7FE113116D98 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  101 3356 20764 20764 39153 39153 8334
    209.124.176.223 from 209.124.176.223 (209.124.176.223)
      Origin IGP, localpref 100, valid, external
      Community: 101:20100 101:20110 101:22100 3356:2 3356:22 3356:100 3356:123 3356:501 3356:903 3356:2065 20764:1154 20764:1202 20764:1301 20764:1411 20764:1434 20764:1464 20764:1474 20764:1504 20764:1513 20764:1533 20764:1544 20764:1640 20764:1650 20764:1660 20764
:1670 20764:3002 20764:3011 20764:3021 39153:10 39153:504
      Extended Community: RT:101:22100
      path 7FE159029378 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  852 3257 28917 39153 39153 8334
    154.11.12.212 from 154.11.12.212 (96.1.209.43)
      Origin IGP, metric 0, localpref 100, valid, external
      path 7FE0FB726CA0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  2497 3257 28917 39153 39153 8334
    202.232.0.2 from 202.232.0.2 (58.138.96.254)
      Origin incomplete, localpref 100, valid, external
      path 7FE0C2A1BC50 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 3
  3303 6939 39153 8334
    217.192.89.50 from 217.192.89.50 (138.187.128.158)
      Origin IGP, localpref 100, valid, external
      Community: 3303:1006 3303:1021 3303:1030 3303:3067 6939:7154 6939:8233 6939:9002
      path 7FE13EF6DB10 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  4901 6079 3257 28917 39153 39153 8334
    162.250.137.254 from 162.250.137.254 (162.250.137.254)
      Origin incomplete, localpref 100, valid, external
      Community: 65000:10100 65000:10300 65000:10400
      path 7FE022A442B8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7660 2516 12389 39153 39153 39153 8334
    203.181.248.168 from 203.181.248.168 (203.181.248.168)
      Origin incomplete, localpref 100, valid, external
      Community: 2516:1050 7660:9003
      path 7FE0F227F888 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7018 3257 28917 39153 39153 8334
    12.0.1.63 from 12.0.1.63 (12.0.1.63)
      Origin incomplete, localpref 100, valid, external
      Community: 7018:5000 7018:37232
      path 7FE097A72DC0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1

```
2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.
```bash
iface dummy0 inet static
pre-up ip link add dummy0 type dummy
address 192.168.99.99
netmask 255.255.255.0

auto dummy1
iface dummy1 inet static
pre-up ip link add dummy1 type dummy
address 192.168.9.9
netmask 255.255.255.0

root@vagrant:/home/vagrant# ifconfig
dummy0: flags=195<UP,BROADCAST,RUNNING,NOARP>  mtu 1500
        inet 192.168.99.99  netmask 255.255.255.0  broadcast 192.168.99.255
        inet6 fe80::d08b:acff:fe04:944d  prefixlen 64  scopeid 0x20<link>
        ether d2:8b:ac:04:94:4d  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1  bytes 70 (70.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.2.15  netmask 255.255.255.0  broadcast 10.0.2.255
        inet6 fe80::a00:27ff:fe73:60cf  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:73:60:cf  txqueuelen 1000  (Ethernet)
        RX packets 22528  bytes 1832850 (1.8 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 21158  bytes 2256827 (2.2 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 232  bytes 21148 (21.1 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 232  bytes 21148 (21.1 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

root@vagrant:/home/vagrant# ip route add 192.168.98.1 via 192.168.99.99
root@vagrant:/home/vagrant# ip route
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
192.168.98.1 via 192.168.99.99 dev dummy0
192.168.99.0/24 dev dummy0 proto kernel scope link src 192.168.99.99

```
3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.

```bash
root@vagrant:/home/vagrant# ss -ltp
State                    Recv-Q                    Send-Q                                       Local Address:Port                                         Peer Address:Port                   Process
LISTEN                   0                         4096                                         127.0.0.53%lo:domain                                            0.0.0.0:*                       users:(("systemd-resolve",pid=595,fd=13))
LISTEN                   0                         128                                                0.0.0.0:ssh                                               0.0.0.0:*                       users:(("sshd",pid=896,fd=3))
LISTEN                   0                         4096                                               0.0.0.0:sunrpc                                            0.0.0.0:*                       users:(("rpcbind",pid=594,fd=4),("systemd",pid=1,fd=35))
LISTEN                   0                         128                                                   [::]:ssh                                                  [::]:*                       users:(("sshd",pid=896,fd=4))
LISTEN                   0                         4096                                                  [::]:sunrpc                                               [::]:*                       users:(("rpcbind",pid=594,fd=6),("systemd",pid=1,fd=37))
```

4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?

```bash
root@vagrant:/home/vagrant# ss -lun
State                           Recv-Q                          Send-Q                                                    Local Address:Port                                                   Peer Address:Port                          Process
UNCONN                          0                               0                                                               0.0.0.0:111                                                         0.0.0.0:*
UNCONN                          0                               0                                                         127.0.0.53%lo:53                                                          0.0.0.0:*
UNCONN                          0                               0                                                        10.0.2.15%eth0:68                                                          0.0.0.0:*
UNCONN                          0                               0                                                                  [::]:111                                                            [::]:*

53 -- DNS
68 - DHCP
111 -- sunrpc
```

5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали. 

[ТЫК](netology.drawio.svg)

