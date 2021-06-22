#!/bin/bash
# Autor: Barckcode
# Version: 0.1
# Description: Script to deploy

LOG="/tmp/deploy.log"
BLOG_SERVICE="flask_blog"

docker service update $BLOG_SERVICE --force >> $LOG
