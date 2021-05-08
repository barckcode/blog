#!/bin/bash
# Autor: Barckcode
# Description: Script to deploy in production

######################### VARS
# Binaries
BINARY="/bin"
USR_BINARY="/usr/bin"

# Paths
SOURCE_CODE="/var/www/helmcode.com"
LOG_PATH="/tmp/deploy.log"

# Commands
DATE="$(date):"

######################### SCRIPT
echo "*********************************************" >> $LOG_PATH
echo $DATE >> $LOG_PATH
cd $SOURCE_CODE

$USR_BINARY/git checkout . >> $LOG_PATH
$USR_BINARY/git pull >> $LOG_PATH
$USR_BINARY/docker restart flask_app >> $LOG_PATH

if [[ $? -eq 0 ]]
then
    echo "$DATE Restart de flask_app ejecutado con éxito" >> $LOG_PATH
else
    echo "$DATE ERROR - Restart de flask_app ejecutado sin éxito" >> $LOG_PATH
fi
