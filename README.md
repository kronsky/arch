Установка Arch linux
=====================

* curl -OL git.io/kronsky-arch.sh
* chmod +x kronsky-arch.sh
* ./kronsky-arch.sh

Для установки по wi-fi:
Смотрим имя адаптера:
* ip link
Подключаемся через Wi-fi:
* iwctl
* station device connect SSID
(SSID - имя сети, device - имя адаптера)
