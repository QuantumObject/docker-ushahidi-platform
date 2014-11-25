#!/bin/bash


#need to be fix for container enviroment including running database while it is modified it 
mkdir /var/www/ushahidi-dev
cd /var/www/ushahidi-dev/
git clone https://github.com/ushahidi/platform.git
chmod 770 application/config/config.php
chmod 770 application/config
chmod 770 application/cache
chmod 770 application/logs
chmod 770 media/uploads
chmod 770 .htaccess
sudo mysqladmin -u root --password create ushahidi-dev

#reason of this script is that dockerfile only execute one command at the time but we need sometimes at the moment we create 
#the docker image to run more that one software for expecified configuration like when you need mysql running to chnage or create
#database for the container ...
