#!/bin/bash

#скрипт при запуске отправит на zabbix-backup скрипт для настройки и архив со скриптами для бэкапа

ssh-keygen -f "/home/sam/.ssh/known_hosts" -R "10.130.0.103" &&
ssh-keygen -f "/home/sam/.ssh/known_hosts" -R "10.130.0.101" &&
ssh-keygen -f "/home/sam/.ssh/known_hosts" -R "51.250.33.9" &&
ssh-keygen -f "/home/sam/.ssh/known_hosts" -R "10.129.0.101" &&
ssh-keygen -f "/home/sam/.ssh/known_hosts" -R "10.130.0.100" &&
ssh-keygen -f "/home/sam/.ssh/known_hosts" -R "10.129.0.100"

tar -czf /home/sam/diplom_tmp/script.tar.gz -C /home/sam/diplom_tmp script &&
scp /home/sam/diplom_tmp/install_zabbix.sh zabbix-backup:/tmp/ &&
scp /home/sam/diplom_tmp/script.tar.gz zabbix-backup:/tmp/ &&
rm /home/sam/diplom_tmp/script.tar.gz
