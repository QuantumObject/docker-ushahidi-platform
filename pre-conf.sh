#!/bin/bash

#trying to change from git clone to downloading directly from zip ....

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
 
 COOKIE_SALT=`pwgen -c -n -1 32`
 cd /var/www/
 # git clone https://github.com/ushahidi/platform.git
 wget https://github.com/ushahidi/platform/releases/download/v4.4.1/ushahidi-platform-bundle-v4.4.1.tar.gz
 ver=$(tar -tf ushahidi-platform-bundle-v4.4.1.tar.gz | head -n1 | tr -d /)
 tar -xvf ushahidi-platform-bundle-v4.4.1.tar.gz && mv $ver /var/www/platform
 rm ushahidi-platform-bundle-v4.4.1.tar.gz

 cd /var/www/platform/
 # git checkout develop
 
 echo "
APP_ENV=local
APP_DEBUG=false
APP_KEY=SomeRandomKey!!!SomeRandomKey!!!
APP_TIMEZONE=UTC
DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=ushahidi
DB_USERNAME=ushahidiuser
DB_PASSWORD=ushahidipasswd
CACHE_DRIVER=file
QUEUE_DRIVER=sync
MAINTENANCE_MODE=0
 " > /var/www/platform/.env
 
 php artisan migrate
 
 #fix update of self composer permision. 
 chown -R www-data:www-data /var/www/platform/storage/{logs,app,framework}
 php artisan passport:keys
 
 mv /var/www/platform/httpdocs/template.htaccess /var/www/platform/httpdocs/.htaccess
  
 chown -R www-data:www-data /var/www
 chmod -R g+rwX /var/www/platform
 chmod -R 770 /var/www/platform/storage
	
echo "#MAILTO=<your email address for system alerts>
*/5 * * * * cd /var/www/platform && ./artisan datasource:outgoing >> /dev/null
*/5 * * * * cd /var/www/platform && ./artisan datasource:incoming >> /dev/null
*/5 * * * * cd /var/www/platform && ./artisan savedsearch:sync >> /dev/null
*/5 * * * * cd /var/www/platform && ./artisan notification:queue >> /dev/null
*/5 * * * * cd /var/www/platform && ./artisan webhook:send >> /dev/null
" | crontab -u www-data -
  
 rm -R /var/www/html
 
 #to fix error relate to ip address of container apache2
 echo "ServerName localhost" | tee /etc/apache2/conf-available/fqdn.conf
 ln -s /etc/apache2/conf-available/fqdn.conf /etc/apache2/conf-enabled/fqdn.conf
 
 a2enmod rewrite
 a2enmod headers

(! pidof mysqld) || kill -9 $(pidof mysqld)

sleep 3s
