#!/bin/bash
# Каталоги
WIKI_FS="/backup/wiki_fs"
TMP_DIR="/tmp/wiki_fs"
IP_WIKI="10.129.0.101"
DATE=$(date +%Y%m%d_%H%M)

mkdir -p "$TMP_DIR"
sudo chown sam:sam "$TMP_DIR"

# Резервное копирование файлов с второго приложения
rsync -avz --delete -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" backuser@$IP_WIKI:/var/www/wiki/ "$TMP_DIR/"
sudo tar -czf "$WIKI_FS/wiki-fs_${DATE}.tar.gz" -C /tmp wiki_fs

# Очистка временной директории
rm -rf "$TMP_DIR"/*
echo "Бэкап ФС в $DATE выполен"