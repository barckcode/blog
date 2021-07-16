######################### VARS
# Logs
LOG_SCRIPT="/tmp/deploy_blog.log"

# APP
PATH_APP="/var/www/helmcode_com"

sudo /bin/rm -rf $PATH_APP/* >> $LOG_SCRIPT