#!/bin/bash

# Конфигурация
PGPORT=9776
PGUSER=postgres4
BACKUP_DIR="$HOME/backups/base"
DATE=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS_LOCAL=7
REMOTE_HOST="postgres4@reserved_node"
REMOTE_BACKUP_DIR="~/backups/base"
LOG_FILE="$HOME/backup.log"

echo "[$(date)] === НАЧАЛО БЭКАПА ===" >> $LOG_FILE

# pg_basebackup с включением WAL
pg_basebackup -h localhost -p $PGPORT -U $PGUSER \
    -D $BACKUP_DIR/base_backup_$DATE \
    -Ft -z -P -X fetch 2>> $LOG_FILE

if [ $? -eq 0 ]; then
    echo "[$(date)] Бэкап создан: base_backup_$DATE" >> $LOG_FILE
    
    # Копирование на резервный узел
    ssh $REMOTE_HOST "mkdir -p $REMOTE_BACKUP_DIR" 2>> $LOG_FILE
    scp $BACKUP_DIR/base_backup_$DATE.tar.gz $REMOTE_HOST:$REMOTE_BACKUP_DIR/ 2>> $LOG_FILE
    
    # Удаление старых бэкапов на основном узле (старше 7 дней)
    find $BACKUP_DIR -name "base_backup_*.tar.gz" -mtime +$RETENTION_DAYS_LOCAL -delete
else
    echo "[$(date)] ОШИБКА создания бэкапа!" >> $LOG_FILE
fi

echo "[$(date)] === ЗАВЕРШЕНИЕ ===" >> $LOG_FILE