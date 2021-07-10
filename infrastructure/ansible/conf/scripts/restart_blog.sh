#!/bin/bash
# Autor: Barckcode
# Description: Script to restart Blog containers after deploy.

######################### VARS
# Logs
LOG_SCRIPT="/tmp/deploy_blog.log"

# Commands
DATE="$(date):"

# Services
PRO_APP="flask_blog"

######################### SCRIPT
/usr/bin/docker service update $PRO_APP --force
