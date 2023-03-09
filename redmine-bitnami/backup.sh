#!/bin/bash

# these variable must be changed!!
PASSWORD=pa33word

# config
DIR_NAME=$(basename $PWD)
BACKUP_DIR=/home/$(whoami)/backups
BACKUP_NAME=${DIR_NAME}.database
DATE=$(date '+%Y-%m-%d')
ID=$(docker ps -aqf name=${DIR_NAME}_postgres)

# create backup folder
mkdir -p ${BACKUP_DIR}

# backup db
docker exec -it ${ID} pg_dumpall -c -U ${DIR_NAME} > ${BACKUP_NAME}.sql
gzip -N -9 -c ${BACKUP_NAME}.sql > ${BACKUP_NAME}.gz
openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt -pass pass:${PASSWORD} -in ${BACKUP_NAME}.gz -out ${BACKUP_DIR}/${DATE}-${BACKUP_NAME}.enc

# remove tmp files
rm ${BACKUP_NAME}.sql ${BACKUP_NAME}.gz

# backup attachments
RBACKUP_NAME=${DIR_NAME}.attachments
RID=$(docker run -d -v ${DIR_NAME}_${DIR_NAME}_data:/attachments busybox:latest true)
docker cp ${RID}:/attachments ./
docker rm ${RID} > /dev/null
tar -zcf ${RBACKUP_NAME}.gz attachments
openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt -pass pass:${PASSWORD} -in ${RBACKUP_NAME}.gz -out ${BACKUP_DIR}/${DATE}-${RBACKUP_NAME}.enc

rm -rf attachments ${RBACKUP_NAME}.gz