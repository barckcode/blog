#!/bin/bash
# Autor: Barckcode
# Version: 1.0
# Description: Script to deploy

LOG="/tmp/deploy.log"
DEPLOY_SCRIPT="/tmp/deploy.sh"
APP_SERVICE="$1"

echo "****************************" >> $LOG
echo "-> Actualizando el servicio: $APP_SERVICE" >> $LOG
docker service update $APP_SERVICE --force >> $LOG

echo "-> Eliminando el script temporal de deploy: $DEPLOY_SCRIPT" >> $LOG
rm $DEPLOY_SCRIPT >> $LOG
echo "-> Deploy ejecutado con éxito!" >> $LOG
