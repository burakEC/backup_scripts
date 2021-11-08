#!/bin/bash

TARIH=$(date +"%Y%m%d_%H%M%S")

timestamp() {
  echo $(date +"%Y%m%d %H:%M:%S")
}

#### Komut kullanimini ekrana bas ########
usage()
{
cat << EOF
KULLANIMI:
postgresql-backup.sh [docker container adi] [hedef dizin]
ORNEK:
postgresql-backup.sh legalite_db /LEGA_DB_BACKUPS/legalite_db_data/
EOF
}

if [ -z "$1" ] || [ -z "$2" ]
	then
                usage
        else
	echo $(timestamp)" backup basladi..."
	docker exec -t $1 pg_dumpall -c -U postgres | gzip > $2/legalite_db_$(date +"%Y_%m_%d_%H%M").gz
	echo $(timestamp)" backup tamamlandi..."
fi
