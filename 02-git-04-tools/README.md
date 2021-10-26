# Домашнее задание к занятию «2.4. Инструменты Git»

Для выполнения заданий в этом разделе давайте склонируем репозиторий с исходным кодом 
терраформа https://github.com/hashicorp/terraform 

В виде результата напишите текстом ответы на вопросы и каким образом эти ответы были получены. 

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на `aefea`.

`commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545`

`Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>`

`Date:   Thu Jun 18 10:29:58 2020 -0400`

`Update CHANGELOG.md`

---

2. Какому тегу соответствует коммит `85024d3`?

`v0.12.23`

---

3. Сколько родителей у коммита `b8d720`? Напишите их хеши.

`2 родителя` -- `56cd7859e05c36c06b56d013b55a252d0bb7e158 и 9ea88f22fc6269854151c571162c5bcf958bee2b`

---

4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами  v0.12.23 и v0.12.24.

`git log --pretty=format:'%h %s' v0.12.23..v0.12.24`

`33ff1c03b v0.12.24`

`b14b74c49 [Website] vmc provider links`

`3f235065b Update CHANGELOG.md`

`6ae64e247 registry: Fix panic when server is unreachable`

`5c619ca1b website: Remove links to the getting started guide's old location`

`06275647e Update CHANGELOG.md`

`d5f9411f5 command: Fix bug when using terraform login on Windows`

`4b6d06cc5 Update CHANGELOG.md`

`dd01a3507 Update CHANGELOG.md`

`225466bc3 Cleanup after v0.12.23 release`

---

5. Найдите коммит в котором была создана функция `func providerSource`, ее определение в коде выглядит 
так `func providerSource(...)` (вместо троеточего перечислены аргументы).

`8c928e83589d90a031f811fae52a81be7153e82f`

Команда:
`ubuntu@DESKTOP-S3C1B72:/mnt/c/Users/Marker/PycharmProjects/terraform$ git log -S"func providerSource(" --oneline`

`8c928e835 main: Consult local directories as potential mirrors of providers`

`ubuntu@DESKTOP-S3C1B72:/mnt/c/Users/Marker/PycharmProjects/terraform$ git show 8c928e835`

`commit 8c928e83589d90a031f811fae52a81be7153e82f`

---

6. Найдите все коммиты в которых была изменена функция `globalPluginDirs`.

`git log -L ":globalPluginDirs:plugins.go" --oneline --no-patch`

`78b122055 Remove config.go and update things using its aliases`

`52dbf9483 keep .terraform.d/plugins for discovery`

`41ab0aef7 Add missing OS_ARCH dir to global plugin paths`

`66ebff90c move some more plugin search path logic to command`

`8364383c3 Push plugin discovery down into command package`

---

8. Кто автор функции `synchronizedWriters`? 

`ubuntu@DESKTOP-S3C1B72:/mnt/c/Users/Marker/PycharmProjects/terraform$ git log -S"synchronizedWriters" --oneline`

`bdfea50cc remove unused`

`fd4f7eb0b remove prefixed io`

`5ac311e2a main: synchronize writes to VT100-faker on Windows`

`ubuntu@DESKTOP-S3C1B72:/mnt/c/Users/Marker/PycharmProjects/terraform$ git show 5ac311e2a`

`commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5`

`Author: Martin Atkins <mart@degeneration.co.uk>`

---
