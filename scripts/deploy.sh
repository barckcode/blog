#!/bin/bash
# Autor: Barckcode
# Description: Script to deploy in pro/pre

######################### VARS
# Parameters
ENV=$1

# Binaries
BINARY="/bin"
USR_BINARY="/usr/bin"

# Source
SOURCE_CODE="/var/www/helmcode.com"
SOURCE_CODE_PRE="/var/www/pre_helmcode.com"

# Logs
LOG_SCRIPT="/tmp/deploy.log"

# Commands
DATE="$(date):"

# Containers
PRO_APP="flask_app"
PRE_APP="flask_app_pre"

######################### SCRIPT
# Parameter validation
if [[ -n $ENV  ]]
then
    echo "*********************************************" >> $LOG_SCRIPT
    echo $DATE >> $LOG_SCRIPT
    echo "Entorno elegido: $ENV" >> $LOG_SCRIPT

    # Enviroment validation
    if [[ $ENV == "PRO" ]]
    then
        cd $SOURCE_CODE
        $USR_BINARY/git checkout main >> $LOG_SCRIPT
        $USR_BINARY/git checkout . >> $LOG_SCRIPT
        $USR_BINARY/git pull >> $LOG_SCRIPT

        if [[ $? -eq 0 ]]
        then
            echo "$DATE Pull ejecutado con éxito" >> $LOG_SCRIPT
            $USR_BINARY/docker restart $PRO_APP >> $LOG_SCRIPT

            if [[ $? -eq 0 ]]
            then
                echo "$DATE Restart de $PRO_APP ejecutado con éxito" >> $LOG_SCRIPT
                exit 0
            else
                echo "$DATE ERROR - Restart de $PRO_APP ejecutado sin éxito" >> $LOG_SCRIPT
                exit 1
            fi
        else
            echo "$DATE ERROR - Pull ejecutado sin éxito" >> $LOG_SCRIPT
            exit 1
        fi
    elif [[ $ENV == "PRE" ]]
    then
        cd $SOURCE_CODE_PRE
        $USR_BINARY/git checkout pre >> $LOG_SCRIPT
        $USR_BINARY/git checkout . >> $LOG_SCRIPT
        $USR_BINARY/git pull origin pre >> $LOG_SCRIPT

        if [[ $? -eq 0 ]]
        then
            echo "$DATE Pull ejecutado con éxito" >> $LOG_SCRIPT
            $USR_BINARY/docker restart $PRE_APP >> $LOG_SCRIPT

            if [[ $? -eq 0 ]]
            then
                echo "$DATE Restart de $PRE_APP ejecutado con éxito" >> $LOG_SCRIPT
                exit 0
            else
                echo "$DATE ERROR - Restart de $PRE_APP ejecutado sin éxito" >> $LOG_SCRIPT
                exit 1
            fi
        else
            echo "$DATE ERROR - Pull ejecutado sin éxito" >> $LOG_SCRIPT
            exit 1
        fi
    else
        echo "$DATE ERROR - El parámetro indicado no corresponde a ninguno de los entornos disponibles [ PRO / PRE ]" >> $LOG_SCRIPT
        exit 1
    fi
else
    echo "*********************************************" >> $LOG_SCRIPT
    echo $DATE >> $LOG_SCRIPT
    echo "$DATE ERROR - No se ha enviado ningún parámetro al script para indicar el entorno: $ENV" >> $LOG_SCRIPT
    exit 1
fi
