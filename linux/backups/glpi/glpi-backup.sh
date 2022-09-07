#!/bin/bash
################################################################
##
## MySQL Database Backup Script
## Written By: Yehiweb
## URL: https://yehiweb.com/wp-content/uploads/2021/05/mysql-backup.sh
## Last Update: May 17, 2021
##
################################################################

export PATH=/bin:/usr/bin:/usr/local/bin
TODAY=`date +"%d%b%Y"`

################################################################
################## Update below values ########################

BACKUP_PATH='/opt/backup/glpi'
SITE='glpi.ztime.ru'
GLPI_PATH=/var/www/${SITE}
MYSQL_HOST='localhost'
MYSQL_PORT='3306'
MYSQL_USER=''
MYSQL_PASSWORD=''
DATABASE_NAME=''
BACKUP_RETAIN_DAYS=30 ## Number of days to keep local backup copy

#################################################################

##### Backups files #####

mkdir -p ${BACKUP_PATH}
mkdir -p ${BACKUP_PATH}/${TODAY}
mkdir -p ${BACKUP_PATH}/${TODAY}/www

tar -cvzf ${BACKUP_PATH}/${TODAY}/www/www-${SITE}-${TODAY}.tgz ${GLPI_PATH}

echo "Files backup successfully completed"

##### Backups database #####

mkdir -p ${BACKUP_PATH}
mkdir -p ${BACKUP_PATH}/${TODAY}
mkdir -p ${BACKUP_PATH}/${TODAY}/base


echo "Backup started for database - ${DATABASE_NAME}"

mysqldump -h ${MYSQL_HOST} \
-P ${MYSQL_PORT} \
-u ${MYSQL_USER} \
-p${MYSQL_PASSWORD} \
${DATABASE_NAME} | gzip > ${BACKUP_PATH}/${TODAY}/base/base-${DATABASE_NAME}-${TODAY}.sql.gz

if [ $? -eq 0 ]; then
echo "Database backup successfully completed"
else
echo "Error found during backup"
exit 1
fi

##### Remove backups older than {BACKUP_RETAIN_DAYS} days #####

DBDELDATE=`date +"%d%b%Y" --date="${BACKUP_RETAIN_DAYS} days ago"`

if [ ! -z ${BACKUP_PATH} ]; then
cd ${BACKUP_PATH}
if [ ! -z ${DBDELDATE} ] && [ -d ${DBDELDATE} ]; then
rm -rf ${DBDELDATE}
fi
fi

### End of script ####
