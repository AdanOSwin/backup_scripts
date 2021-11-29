#!/bin/bash

##myqsl backup script 
##author: Adan Ruiz


export PATH=/bin:/usr/bin:/usr/local/bin
TODAY=`date`

DABATABASE_BACKUP_PATH='/backup/dbbackup'
MYSQL_HOST='localhost'
MYSQL_PORT='3306'
MYSQL_USER='root' ##it can be changed to another user in the database
MYSQL_PASSWORD=''
DATBASE_NAME='task_db'
BACKUP_DB_DAYS_REMAINING=30


mkdir -p ${DABATABASE_BACKUP_PATH}/${TODAY}
echo "Starting backup for database: ${DATABASE_NAME}"

/opt/lampp/bin/mysqldump -h ${MYSQL_HOST} \
 -P ${MYSQL_PORT} \
 -u ${MYSQL_USER} \
 ##-p${MYSQL_PASSWORD} \ 
  ${DATBASE_NAME} | gzip > ${DABATABASE_BACKUP_PATH}/${TODAY}/${DATBASE_NAME}-${TODAY}.sql.gzip

if [ $? -eq 0 ]; then
  echo "Database backup completed"
else
  echo "Error found during backup"
  exit 1
fi

DELETEDBDATE = `date +"%d%b%Y" --date="${BACKUP_DB_DAYS_REMAINING} days ago"`

if [ ! -z ${DABATABASE_BACKUP_PATH} ]; then
  cd ${DABATABASE_BACKUP_PATH}
  if [ ! -z ${DELETEDBDATE} ] && [ -d ${DELETEDBDATE} ]; then
    rm -rf ${DELETEDBDATE}
  fi
fi

