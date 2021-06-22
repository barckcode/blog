#!/bin/bash
# Autor: Barckcode
# Version: 1.0
# Description: Script to prepare code to deploy


############################# Global Vars #############################
LOG="/tmp/deploy.log"
SOURCE_PATH="/home/admin/apps"
SRC_DEPLOY_SCRIPT="/home/admin/scripts/deploy.sh"
DEST_DEPLOY_SCRIPT="/tmp/deploy.sh"
APP="$1"


########################## Global Funtions ############################
sync_code () {
  echo "-> Haciendo pull del repositorio:" >> $LOG
  sudo runuser -l admin -c "cd $SOURCE_PATH && git pull" >> $LOG
  echo "-> Sincronizando codigo desde sauron a los frontales:" >> $LOG
  sudo runuser -l admin -c "rsync -avhz $SOURCE_PATH/$APP/* web01:$1" >> $LOG
}


############################ Start Script #############################
if [[ -e $SRC_DEPLOY_SCRIPT ]]
then
  echo "****************************" >> $LOG
  echo "-> Preparando el deploy..." >> $LOG
  echo "-> $(date)" >> $LOG
  # Copy temporal script in webas
  echo "-> Copiando script temporal de deploy en los frontales: $DEST_DEPLOY_SCRIPT" >> $LOG
  sudo runuser -l admin -c "rsync -avhz $SRC_DEPLOY_SCRIPT web01:$DEST_DEPLOY_SCRIPT" >> $LOG
  echo "-> Aplicacion seleccionada: $APP" >> $LOG

  if [[ $APP == "blog" ]]
  then
    WEBAS_PATH="/var/www/helmcode_com"
    # Sync app code
    sync_code "$WEBAS_PATH"
    echo "Codigo de la aplicacion $APP listo!" >> $LOG
    exit 0
  else
    echo "La aplicacion seleccionada no es válida" >> $LOG
    # ERROR 5: 	Input/output error - $APP
    exit 5
  fi
else
  echo "-> El script de deploy no existe: $SRC_DEPLOY_SCRIPT" >> $LOG
  # ERROR 2: No such file or directory - $DEST_DEPLOY_SCRIPT
  exit 2
fi
