#!/bin/bash
# Autor: Barckcode
# Version: 0.1
# Description: Script to prepare code to deploy


LOG="/tmp/deploy.log"
SOURCE_PATH="/home/admin/apps"
WEBAS_PATH="/var/www/helmcode_com/"


echo "****************************" >> $LOG
echo "-> Preparando el deploy..." >> $LOG
echo "-> $(date)" >> $LOG
echo "-> Haciendo pull del repositorio:" >> $LOG
sudo runuser -l admin -c "cd $SOURCE_PATH && git pull" >> $LOG
echo "-> Sincronizando codigo desde sauron a los frontales:" >> $LOG
sudo runuser -l admin -c "rsync -avhz $SOURCE_PATH/blog/* web01:$WEBAS_PATH" >> $LOG
