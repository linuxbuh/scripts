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

BACKUP_PATH='/opt/backup/zabbix-server'
MYSQL_HOST='localhost'
MYSQL_PORT='3306'
MYSQL_USER='dbuzabbix'
MYSQL_PASSWORD='eShie5oGiw'
DATABASE_NAME='db4zabbix'
BACKUP_RETAIN_DAYS=30 ## Number of days to keep local backup copy

#################################################################

##### Backups files #####

mkdir -p ${BACKUP_PATH}
mkdir -p ${BACKUP_PATH}/${TODAY}/etc
mkdir -p ${BACKUP_PATH}/${TODAY}/etc/zabbix
mkdir -p ${BACKUP_PATH}/${TODAY}/etc/nginx
mkdir -p ${BACKUP_PATH}/${TODAY}/etc/php-fpm.d
mkdir -p ${BACKUP_PATH}/${TODAY}/etc/php.d
mkdir -p ${BACKUP_PATH}/${TODAY}/etc/httpd
mkdir -p ${BACKUP_PATH}/${TODAY}/usr
mkdir -p ${BACKUP_PATH}/${TODAY}/usr/share
mkdir -p ${BACKUP_PATH}/${TODAY}/usr/share/zabbix

cp -f -R /etc/zabbix/* ${BACKUP_PATH}/${TODAY}/etc/zabbix/
cp -f -R /etc/nginx/* ${BACKUP_PATH}/${TODAY}/etc/nginx/
cp -f -R /etc/php-fpm.d/* ${BACKUP_PATH}/${TODAY}/etc/php-fpm.d/
cp -f -R /etc/php.d/* ${BACKUP_PATH}/${TODAY}/etc/php.d/
cp -f -R /etc/httpd/* ${BACKUP_PATH}/${TODAY}/etc/httpd/
cp -f -R /usr/share/zabbix/* ${BACKUP_PATH}/${TODAY}/usr/share/zabbix/

if [ $? -eq 0 ]; then
echo "Files backup successfully completed"
else
echo "Error found during backup"
exit 1
fi

##### Backups database #####

mkdir -p ${BACKUP_PATH}/${TODAY}
echo "Backup started for database - ${DATABASE_NAME}"

mysqldump -h ${MYSQL_HOST} \
-P ${MYSQL_PORT} \
-u ${MYSQL_USER} \
-p${MYSQL_PASSWORD} \
${DATABASE_NAME} | gzip > ${BACKUP_PATH}/${TODAY}/${DATABASE_NAME}-${TODAY}.sql.gz

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
