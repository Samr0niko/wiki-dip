#!/bin/bash
# Удаление файлов старше 7 дней
DAY="7"
find /backup/bd -type f -mtime +$DAY -exec rm -f {} \;
find /backup/wiki_img -type f -mtime +$DAY -exec rm -f {} \;
find /backup/wiki_fs -type f -mtime +$DAY -exec rm -f {} \;
echo "Очистка бэкапов за $DAY дней выполена"