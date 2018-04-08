#!/bin/bash
#
#        Shell Script sample to Change all WordPress domain name OR String instances
#        After the Find and Replace operation, it will be re-imported back to DB
#
#        Can be used for
#        1. Domain Migration
#        2. Updated Domain to HTTPS
#        3. Find and Replace a string in the whole database
#      
#        ALWAYS KEEP A BACKUP OF THE DB
#
#
#        Basic Usage in console as: sh wpchangedomain.sh
#
#
#        from: www.RuhaniRabin.com
#
MYSQLUSER="mysqlusername"
MYSQLPASSWORD="mysqlpassword"
MYSQLDATABASE="mysqldatabase"
#include the sql extension for DB_BACKUP
DB_BACKUP="exportfile.sql"
DOMAIN_OLD="http://olddomain.com"
DOMAIN_NEW="https://newdomain.com"

#backup mysql
echo ". Dumping database to $DB_BACKUP"
mysqldump -u $MYSQLUSER --password=$MYSQLPASSWORD $MYSQLDATABASE > "$DB_BACKUP" || { echo "ERROR: Could not dump mysql db to $DB_BACKUP"; exit 1; }

#tar and compress backup
echo ".. Creating backup archive $DB_BACKUP.tar.gz"
tar czf "$DB_BACKUP.tar.gz" $DB_BACKUP || { echo "ERROR: Could not create backup archive"; exit 1; }

#Find and replace inside mysql file
echo "... Find and Replace $DOMAIN_OLD"
echo ".... Changing it to $DOMAIN_NEW"
echo "...... Processing $DB_BACKUP"
sed -e "s|$DOMAIN_OLD|$DOMAIN_NEW|gi" $DB_BACKUP -i 
echo "........ Finished Processing $DB_BACKUP"

#Import mysql
echo "........... Re-Importing database from $DB_BACKUP"
mysqldump -u $MYSQLUSER --password=$MYSQLPASSWORD $MYSQLDATABASE < "$DB_BACKUP" || { echo "ERROR: Could not Import mysql db from $DB_BACKUP"; exit 1; }
echo "........... Script Finished"
