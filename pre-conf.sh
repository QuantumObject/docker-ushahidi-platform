#!/bin/bash

#Initial conf for mysql
mysql_install_db
#for configuriing database
/usr/bin/mysqld_safe &
 sleep 3s

 mysqladmin -u root password mysqlpsswd
 mysqladmin -u root -pmysqlpsswd reload
 mysqladmin -u root -pmysqlpsswd create ushahidi

 echo "GRANT ALL ON ushahidi.* TO ushahidiuser@localhost IDENTIFIED BY 'ushahidipasswd'; flush privileges; " | mysql -u root -pmysqlpsswd


 phpenmod imap
 phpenmod mysqli 
 
 #COOKIE_SALT=`pwgen -c -n -1 32`
 cd /var/www/
 git clone https://github.com/ushahidi/platform.git

 curl -sS https://getcomposer.org/installer | php
 mv composer.phar /usr/local/bin/composer
 
 cd /var/www/platform/
 git checkout develop
 
 echo "
APP_ENV=local
APP_DEBUG=true
APP_KEY=SomeRandomKey!!!SomeRandomKey!!!
APP_TIMEZONE=UTC
DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=ushahidi
DB_USERNAME=ushahidiuser
DB_PASSWORD=ushahidipasswd
CACHE_DRIVER=file
MAINTENANCE_MODE=0
 " > /var/www/platform/.env
  
 composer install
 composer migrate
 
 cd /var/www/
 mv /var/www/platform/httpdocs/template.htaccess /var/www/platform/httpdocs/.htaccess

 # Reset the default cookie salt to something unique
 # sed -i -e "s/Cookie::\$salt = '.*';/Cookie::\$salt = '$COOKIE_SALT';/" platform/application/bootstrap.php 

 chown -R www-data:www-data platform/storage/{logs,framework/cache,app}
 chmod 775 platform/storage/{logs,framework/cache,app}
 chmod 775 platform/httpdocs/.htaccess

 rm -R /var/www/html
 
  #to fix error relate to ip address of container apache2
  echo "ServerName localhost" | tee /etc/apache2/conf-available/fqdn.conf
  ln -s /etc/apache2/conf-available/fqdn.conf /etc/apache2/conf-enabled/fqdn.conf
 
 a2enmod rewrite
 a2enmod headers


killall mysqld
sleep 3s
