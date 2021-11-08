#!/bin/bash

timestamp() {
  date +"%Y%m%d %H:%M:%S"
}


USER="backupuser"
PASS="password"

#### Komut kullanimini ekrana bas ########
usage()
{
cat << EOF
KULLANIMI:
mongo-backup.sh [docker container adi] [mongo DB adi] [hedef dizin]
ORNEK:
mongo-backup.sh legalite_mongodb legalite /LEGA_DB_BACKUPS/legalite_mongo_data/
EOF
}	

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] 
	then
        	usage
	else
		timestamp
		TEMP_DIR=/Archive/tmp/$1
		echo "$TEMP_DIR gecici dizini yaratiliyor..."
		mkdir -p $TEMP_DIR
		
		timestamp
		TARGET_DIR=${3%/}
		echo "$TARGET_DIR hedef dizini yaratiliyor... "
		mkdir -p $TARGET_DIR/

		echo 'mongodump -u legalite -p "''$PASS''" --out /backup --host $MONGO_PORT_27017_TCP_ADDR --db '$2' --authenticationDatabase admin'

		docker run --rm --privileged=true --link $1:mongo -v $TEMP_DIR:/backup mongo bash -c 'mongodump -u '$USER' -p '$PASS' --out /backup --host $MONGO_PORT_27017_TCP_ADDR --db '$2' --authenticationDatabase admin' 
		
		timestamp
		echo "Mongo dump dosyasi tarlaniyor..."
		BACKUP_FILE=$TARGET_DIR"/"$(date +"%Y%m%d_%H%M%S")_$2.tar
		
		tar -cvf $BACKUP_FILE -C $TEMP_DIR"/"$2 .
		
		timestamp
		echo "Gecici dizinler siliniyor..."
		rm -rf $TEMP_DIR
fi
