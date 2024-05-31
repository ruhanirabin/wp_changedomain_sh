#!/bin/bash
#
#        Shell Script to Change all WordPress domain name OR String instances
#        After the Find and Replace operation, it will be re-imported back to DB
#
#        Can be used for:
#        1. Domain Migration
#        2. Update Domain to HTTPS
#        3. Find and Replace a string in the whole database
#      
#        ALWAYS KEEP A BACKUP OF THE DB
#
#        Basic Usage in console as: sh wpchangedomain.sh
#
#        from: www.RuhaniRabin.com
#

# Configurable variables
MYSQLUSER="mysqlusername"
MYSQLPASSWORD="mysqlpassword"
MYSQLDATABASE="mysqldatabase"
DB_BACKUP="exportfile.sql"  # include the sql extension for DB_BACKUP
DOMAIN_OLD="http://olddomain.com"
DOMAIN_NEW="https://newdomain.com"

# Backup MySQL
echo ". Dumping database to $DB_BACKUP"
mysqldump -u "$MYSQLUSER" -p"$MYSQLPASSWORD" "$MYSQLDATABASE" > "$DB_BACKUP" || { echo "ERROR: Could not dump mysql db to $DB_BACKUP"; exit 1; }

# Tar and compress backup
echo ".. Creating backup archive $DB_BACKUP.tar.gz"
tar czf "$DB_BACKUP.tar.gz" "$DB_BACKUP" || { echo "ERROR: Could not create backup archive"; exit 1; }

# Find and replace inside MySQL file
echo "... Find and Replace $DOMAIN_OLD"
echo ".... Changing it to $DOMAIN_NEW"
echo "...... Processing $DB_BACKUP"
sed -i "s|$DOMAIN_OLD|$DOMAIN_NEW|g" "$DB_BACKUP"
echo "........ Finished Processing $DB_BACKUP"

# Import MySQL
echo "........... Re-Importing database from $DB_BACKUP"
mysql -u "$MYSQLUSER" -p"$MYSQLPASSWORD" "$MYSQLDATABASE" < "$DB_BACKUP" || { echo "ERROR: Could not Import mysql db from $DB_BACKUP"; exit 1; }
echo "........... Script Finished"
