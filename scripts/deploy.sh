#!/bin/bash
# Autor: Barckcode
# Description: Script to deploy in production

BINARY="/bin"
USR_BINARY="/usr/bin"
SOURCE_CODE="/var/www/helmcode.com"

cd $SOURCE_CODE
$USR_BINARY/git pull
$BINARY/systemctl restart nginx

# Logs:
echo "************************" >> /tmp/deploy.log
echo "$? #Salida del reinicio de nginx" >> /tmp/deploy.log
