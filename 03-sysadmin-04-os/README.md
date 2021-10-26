#### 1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:
* поместите его в автозагрузку,
* предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
* удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

```bash
# /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter

[Service]
Type=simple
Restart=always
EnvironmentFile=/home/ubuntu/node_exporter/.node_exporter
ExecStart=/home/ubuntu/node_exporter/node_exporter $EXTRA_OPTS

[Install]
WantedBy = multi-user.target
```
```bash
# 1. поместите его в автозагрузку
systemctl enable node_exporter

# 2. предусмотрите возможность добавления опций к запускаемому процессу через внешний файл

# /home/ubuntu/node_exporter/.node_exporter
EXTRA_OPTS=--collector.disable-defaults --collector.arp

# EnvironmentFile=/home/ubuntu/node_exporter/.node_exporter
# ExecStart=... $EXTRA_OPTS

# 3. удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.
root@ubuntu:/home/ubuntu/node_exporter# systemctl status node_exporter
● node_exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2021-12-08 00:06:57 UTC; 6s ago
   Main PID: 164984 (node_exporter)
      Tasks: 5 (limit: 9257)
     CGroup: /system.slice/node_exporter.service
             └─164984 /home/ubuntu/node_exporter/node_exporter --collector.disable-defaults --collector.arp

Dec 08 00:06:57 ubuntu systemd[1]: Started Node Exporter.
Dec 08 00:06:57 ubuntu node_exporter[164984]: ts=2021-12-08T00:06:57.041Z caller=node_exporter.go:182 level=info msg="Starting node_exporter" version="(version=1.3.1, branch=HEAD, revision=a2321e7b940ddcff26873612bccdf7cd4c42b6b6)"
Dec 08 00:06:57 ubuntu node_exporter[164984]: ts=2021-12-08T00:06:57.041Z caller=node_exporter.go:183 level=info msg="Build context" build_context="(go=go1.17.3, user=root@243aafa5525c, date=20211205-11:10:22)"
Dec 08 00:06:57 ubuntu node_exporter[164984]: ts=2021-12-08T00:06:57.041Z caller=node_exporter.go:185 level=warn msg="Node Exporter is running as root user. This exporter is designed to run as unpriviledged user, root is not required."
Dec 08 00:06:57 ubuntu node_exporter[164984]: ts=2021-12-08T00:06:57.041Z caller=node_exporter.go:108 level=info msg="Enabled collectors"
Dec 08 00:06:57 ubuntu node_exporter[164984]: ts=2021-12-08T00:06:57.042Z caller=node_exporter.go:115 level=info collector=arp
Dec 08 00:06:57 ubuntu node_exporter[164984]: ts=2021-12-08T00:06:57.042Z caller=node_exporter.go:199 level=info msg="Listening on" address=:9100
Dec 08 00:06:57 ubuntu node_exporter[164984]: ts=2021-12-08T00:06:57.042Z caller=tls_config.go:195 level=info msg="TLS is disabled." http2=false

```

#### 2. Ознакомьтесь с опциями `node_exporter` и выводом /metrics по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
1. cpu
2. diskstats
3. filesystem
4. meminfo
5. netstat
6. vmstat

#### 3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). После успешной установки:
* в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
* добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

```yaml
version: '3'
services:
  netdata:
    image: netdata/netdata
    container_name: netdata
    hostname: ubuntu # set to fqdn of host
    ports:
      - 19999:19999
    restart: unless-stopped
    cap_add:
      - SYS_PTRACE
    security_opt:
      - apparmor:unconfined
    volumes:
      - netdataconfig:/etc/netdata
      - netdatalib:/var/lib/netdata
      - netdatacache:/var/cache/netdata
      - /etc/passwd:/host/etc/passwd:ro
      - /etc/group:/host/etc/group:ro
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /etc/os-release:/host/etc/os-release:ro

volumes:
  netdataconfig:
  netdatalib:
  netdatacache:
```
После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.

```markdown
Ознакомился
```

#### 4. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
Да
```bash
ubuntu@instance-20211018-0104:~$ dmesg | grep KVM
[    0.288139] DMI: QEMU KVM Virtual Machine, BIOS 1.4.1 12/03/2020
```

#### 5. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?
```bash
fs.nr_open = 1048576

# This denotes the maximum number of file-handles a process can
# allocate. Default value is 1024*1024 (1048576) which should be
# enough for most machines. Actual limit depends on RLIMIT_NOFILE
# resource limit.

# ulimit -n
1024
```

#### 6. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.
```bash
unshare -f --pid --mount-proc htop
```

```bash
root@ubuntu:/home/ubuntu# nsenter -t 170081 -p --mount
root@ubuntu:/# ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.3  0.0   8600  4352 pts/0    S+   00:47   0:00 htop
root          14  0.2  0.0   9668  4548 pts/1    S    00:49   0:00 -bash
root          25  0.0  0.0  10188  2832 pts/1    R+   00:49   0:00 ps aux

```

#### 7. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?
```bash
#Fork-бомба, функция, вызывающая саму себя
f(){ 
  f|f &
}
f


[4115908.118933] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-1320.scope
[4116072.921136] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-1327.scope
#Автоматически стабилизирует систему


Если установить ulimit -u 50 - число процессов будет ограниченно 50 для пользоователя. 
```