#!/bin/bash
#this for reference only to create the backup scrips for each container ... the idea to use the same command for each container
#each container will have their own custum backup scritp for it ... 

#Backup mysql
mysqldump -u root -pmysqlpsswd --all-databases > /var/backups/alldb_backup.sql

#Backup importand files relate to app
