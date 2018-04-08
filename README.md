# wp_changedomain.sh
WordPress Change Domain inside DB using Shell / String Replace in All Occurrences

A simple Shell Script to Change all WordPress domain name OR String instances
After the Find and Replace operation, it will be re-imported back to DB

## Can be used for
1. Domain Migration
2. Update Existing Domain to HTTPS
3. Find and Replace a string in the whole database
      
It keeps an archive file just in case


## What does it do actually?
1. It uses `mysqldump` command to export the database specified in the variables
2. Creates a `tar.gz` archive for the named `exported SQL` file
3. Then it performs a linux `SED` find and replace operation inside the SQL file
4. Then, it uses `mysqldump` to re-import the SQL file back into the database

### Basic Usage in console as: 
```
sh wp_changedomain.sh
```

#### from: www.RuhaniRabin.com
