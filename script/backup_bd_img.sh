#!/bin/bash
# Каталоги для хранения бэкапов
BD="/backup/bd"
WIKI_IMG="/backup/wiki_img"
TMP_DIR="/tmp/wiki"
IP_REP="10.129.0.101"
IP_NFS="10.130.0.100"

mkdir -p "$TMP_DIR"
sudo chown sam:sam "$TMP_DIR"

# Текущая дата
DATE=$(date +%Y%m%d_%H%M)

# Резервное копирование БД с реплики 
pg_dumpall -h $IP_REP -U postgres > "$BD/pg_dumpall_${DATE}.sql"

#Резервное копирование изображений с прокси
rsync -avz --delete -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" backuser@$IP_NFS:/srv/shares/wiki-images/ "$TMP_DIR/"
sudo tar -czf "$WIKI_IMG/wiki-images_${DATE}.tar.gz" -C /tmp wiki

# Очистка временной директории
rm -rf "$TMP_DIR"/*
echo "Бэкап БД и images в $DATE выполен"