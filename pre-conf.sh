#!/bin/bash

/usr/bin/mysqld_safe &
 sleep 10s

 mysqladmin -u root password mysqlpsswd
 mysqladmin -u root -pmysqlpsswd reload
 mysqladmin -u root -pmysqlpsswd create ushahidi

 echo "GRANT ALL ON ushahidi.* TO ushahidiuser@localhost IDENTIFIED BY 'ushahidipasswd'; flush privileges; " | mysql -u root -pmysqlpsswd

 #need to be fix for container enviroment including running database while it is modified it 
 cd /var/www/
 git clone https://github.com/ushahidi/platform.git
 git submodule update --init --recursive
 chown -R www-data:www-data /var/www/platform
 #chmod 770 platform/application/config/config.php
 #chmod 770 platform/application/config
 chmod 770 platform/application/cache
 chmod 770 platform/application/logs
 chmod 770 platform/application/media/uploads
 #chmod 770 platform/.htaccess
 rm -R /var/www/html
 a2enmod rewrite
 a2enmod headers


killall mysqld
sleep 10s
