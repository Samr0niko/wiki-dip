#!/bin/bash

#скрипт при запуске настроит zabbix сервер и скрипты для бэкапа

wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu22.04_all.deb
sudo dpkg -i zabbix-release_latest_7.0+ubuntu22.04_all.deb
sudo apt update
sudo apt install postgresql zabbix-server-pgsql zabbix-frontend-php php8.1-pgsql zabbix-nginx-conf zabbix-sql-scripts zabbix-agent -y

sudo rm /etc/nginx/sites-enabled/default
sudo rm /etc/nginx/sites-available/default

sudo -i -u postgres<<EOF
psql -c "CREATE USER zabbix WITH PASSWORD 'qawsed748596' NOSUPERUSER NOCREATEDB NOCREATEROLE;"
createdb -O zabbix zabbix
EOF

zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix
echo "DBPassword=qawsed748596" | sudo tee -a /etc/zabbix/zabbix_server.conf 
sudo sed -i '2s/.*/        listen          8090;/' /etc/zabbix/nginx.conf
sudo sed -i '3s/.*/        #server_name     _;/' /etc/zabbix/nginx.conf

#русский язык
sudo sed -i  "s/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/g" /etc/locale.gen #— раскомментировать строку в файле /etc/locale.gen
sudo locale-gen #— сгенерировать файлы локализации

sudo systemctl restart zabbix-server zabbix-agent nginx php8.1-fpm
sudo systemctl enable zabbix-server zabbix-agent nginx php8.1-fpm

#бэкапы
sudo mkdir -p /backup/bd
sudo mkdir -p /backup/wiki_img
sudo mkdir -p /backup/wiki_fs
sudo chown -R sam:sam /backup
sudo tar -xzf /tmp/script.tar.gz -C /tmp
sudo chown -R sam:sam /tmp/script
sudo mv /tmp/script/*.sh /usr/local/bin/
sudo mv /tmp/script/*.service /etc/systemd/system/
sudo mv /tmp/script/*.timer /etc/systemd/system/
sudo mv /tmp/script/* /home/sam/.ssh/
sudo systemctl daemon-reload
sudo systemctl enable --now backup_bd_img.timer
sudo systemctl enable --now backup_clear.timer
sudo systemctl enable --now backup_fs.timer
