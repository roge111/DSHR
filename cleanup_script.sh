#!/bin/bash

BACKUP_DIR="$HOME/backups/base"
RETENTION_DAYS=30
LOG_FILE="$HOME/cleanup.log"

echo "[$(date)] Очистка бэкапов старше ${RETENTION_DAYS} дней" >> $LOG_FILE

find $BACKUP_DIR -name "base_backup_*.tar.gz" -mtime +$RETENTION_DAYS -delete

COUNT=$(ls -1 $BACKUP_DIR/base_backup_*.tar.gz 2>/dev/null | wc -l)
SIZE=$(du -sh $BACKUP_DIR 2>/dev/null | cut -f1)

echo "[$(date)] Осталось бэкапов: $COUNT, размер: $SIZE" >> $LOG_FILE