#!/bin/bash

ROTATE_PERIOD=1

timestamp() {
  date +"%Y%m%d %H:%M:%S"
}


#### Kullanimini Goster ########
usage()
{
cat << EOF
KULLANIMI:
rotate.sh /hedef_dizin/

SECENEKLER:
-p hedef dizinde gun bazinda geriye donuk silinecek dosyalari belirler. Varsayilan -> $ROTATE_PERIOD

ORNEK:
rotate.sh -p 5 [/hedef dizin/]
EOF
}


#### Getopts #####
while getopts ":p:" opt; do
  case $opt in
    p)
      ROTATE_PERIOD=${OPTARG}
      echo "Rotasyon periyodu: "$ROTATE_PERIOD
      ;;
    \?)
      echo "Gecersiz secenek: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Opsiyon -$OPTARG icin deger atanmali." >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

if [ -z "$1" ]
then
	usage
else

	FILE_COUNT=`find $1 -maxdepth 1 -type f | wc -l`
	DIR=$1
	
	if [ $FILE_COUNT -le 1 ] 
	then 
		echo "$(timestamp): "$DIR" dizinde "$FILE_COUNT " dosya var, islem yapilmiyor."
	else
		echo "$(timestamp): "$DIR" dizinindeki " $ROTATE_PERIOD " gunden eski dosyalar silinecek." 
		find $DIR -type f -mtime +$ROTATE_PERIOD -print -delete
	fi
fi
	
