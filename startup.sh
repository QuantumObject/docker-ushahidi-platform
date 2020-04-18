#!/bin/bash
set -e

function generate_app_key {
    php -r "echo md5(uniqid()).\"\n\";"
}


if [ -f /etc/configured ]; then
        echo 'already configured'
else
      #code that need to run only one time ....
       /usr/bin/mysqld_safe &
      
       # Returns true once mysql can connect.
        mysql_ready() {
                        mysqladmin ping --host=localhost --user=ushahidiuser --password=ushahidipasswd > /dev/null 2>&1
                       }
      
      # waiting for mysql 
      while !(mysql_ready)
        do
                        sleep 3
                        echo "waiting for mysql ..."
        done
      
      
       #need to be move to starup.sh to make sure each container have there own APP_KEY
        cd  /var/www/platform/
        APP_KEY=$(generate_app_key)
        sed  -i "s|APP_KEY=.*|APP_KEY=${APP_KEY}|" /var/www/platform/.env
        
         #run some configuraion files before execution
         cp /var/www/platform/docker/common.sh /common.sh
         cp /var/www/platform/docker/run.run.sh /run.run.sh
         . /run.run.sh
        
        (! pidof mysqld) || kill -9 $(pidof mysqld)
        
        #public key
        echo $APP_KEY
        cat /var/www/platform/storage/passport/oauth-public.key
        
        #needed for fix problem with ubuntu and cron
        update-locale 
        date > /etc/configured
fi
