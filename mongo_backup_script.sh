#!/bin/bash



export PATH=/bin:/usr/bin:/usr/local/bin
TODAY=`date`

##limiting resource consumption
ulimit -m 1024000 -p 8 -v 5000 

DATABASE_BACKUP_PATH='/backup/mongo'
MONGO_HOST='localhost'
MONGO_PORT='27017'

AUTH_ENABLED=0
MONGO_USER=''
MONGO_PASSWORD=''

DATABASE_NAMES='sample_db'

BACKUP_RETAIN_PLAN=30

mkdir -p ${DATABASE_BACKUP_PATH}/${TODAY}

AUTH_PARAM=""

if [ ${AUTH_ENABLED} -eq 1 ]; then
  AUTH_PARAM=" --username ${MONGO_USER} --password ${MONGO_PASSWORD} "
fi

if [ ${DATABASE_NAMES} = "ALL" ]; then
  echo "Creating backup for all the databases"
  mongodump --host ${MONGO_HOST} --port ${MONGO_PORT} ${AUTH_PARAM} --out ${DABATABASE_BACKUP_PATH}/${TODAY}/
else
  echo "Running backup for selected databases"
  for DB_NAME in ${DATABASE_NAMES}
  do
  mongodump --host ${MONGO_HOST} --port ${MONGO_PORT} --db ${DB_NAME} ${AUTH_PARAM} --out ${DATABASE_BACKUP_PATH}/${TODAY}/
  done
fi


DATABASE_DELETE_DATE=`date +"%d%b%Y" --date="${BACKUP_RETAIN_PLAN} days ago"`

if [ ! -z ${DATABASE_BACKUP_PATH} ]; then
  cd ${DATABASE_BACKUP_PATH}
  if [ ! -z ${DATABASE_DELETE_DATE} ] && [ -d ${DATABASE_DELETE_DATE} ]; then
    rm -rf ${DATABASE_DELETE_DATE}
  fi
fi