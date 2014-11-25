#!/bin/bash

/usr/bin/mysqld_safe &
 sleep 10s

 mysqladmin -u root password mysqlpsswd
 mysqladmin -u root -pmysqlpsswd reload
 mysqladmin -u root -pmysqlpsswd create ushahidi

 echo "GRANT ALL ON ushahidi.* TO ushahidiuser@localhost IDENTIFIED BY 'ushahidipasswd'; flush privileges; " | mysql -u root -pmysqlpsswd

 #need to be fix for container enviroment including running database while it is modified it 
 mkdir /var/www/ushahidi
 cd /var/www/ushahidi/
 git clone https://github.com/ushahidi/platform.git
 chmod 770 application/config/config.php
 chmod 770 application/config
 chmod 770 application/cache
 chmod 770 application/logs
 chmod 770 media/uploads
 chmod 770 .htaccess
 rm -R /var/www/html
 a2enmod rewrite


killall mysqld
sleep 10s
