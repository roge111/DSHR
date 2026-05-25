#!/bin/bash

BACKUP_DIR="$HOME/backups/base"
RETENTION_DAYS=30
LOG_FILE="$HOME/cleanup.log"

echo "[$(date)] === ОЧИСТКА БЭКАПОВ СТАРШЕ ${RETENTION_DAYS} ДНЕЙ ===" >> $LOG_FILE

# Удаление директорий бэкапов старше 30 дней
find $BACKUP_DIR -name "base_backup_*" -type d -mtime +$RETENTION_DAYS -exec rm -rf {} \;

# Подсчёт оставшихся бэкапов
COUNT=$(ls -1d $BACKUP_DIR/base_backup_* 2>/dev/null | wc -l)
SIZE=$(du -sh $BACKUP_DIR 2>/dev/null | cut -f1)

echo "[$(date)] Осталось бэкапов: $COUNT, общий размер: $SIZE" >> $LOG_FILE
echo "[$(date)] === ГОТОВО ===" >> $LOG_FILE