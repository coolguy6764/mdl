# Script qui télécharge le mp3 d'une ou plusieurs vidéos,
# renomme les fichiers mp3 contenant des espaces (les remplace par des underscores)
# et intègre l'image passée en paramètre aux nouveaux mp3

# /!\ Attention /!\ 
# Vous devez avoir installé les paquets youtube-dl (nécessaire au téléchargement des mp3)
# et ffmpeg (nécessaire à l'inclusion de l'image aux mp3)

###---------------------------------------------------------------------------------------

#!/bin/bash

help() {
	usage
	echo "
Options:
	-h		Print this help text and exit
	-a \"Artist\"	Set the artist name
	-A \"Album\"	Set the album name
	-g \"Genre\"	Set the genre name
	-y XXXX		Set the year
	-i /absolute/path/to/image
			Set the cover image
	-d /absolute/path/to/destination/directory/
			Set the destination directory to download the mp3 file(s)	
	"
}

usage() {
	echo "Usage: ${0} [OPTIONS] -u URL"
}

exit_abnormal(){
	usage
	exit 1
}


#-----------------------Get options

ARTIST=""
ALBUM=""
GENRE=""
YEAR=""
IMG=""
DEST=""
URL=""

while getopts ":ha:A:g:y:i:d:u:" options; do
	case "${options}" in
		h)
			help
			exit 0
		;;
		a)
			ARTIST=${OPTARG}
		;;
		A)
			ALBUM=${OPTARG}
		;;
		g)
			GENRE=${OPTARG}
		;;
		y)
			YEAR=${OPTARG}
		;;
		i)
			IMG=${OPTARG}
		;;
		d)
			DEST=${OPTARG}
		;;	
		u)
			URL=${OPTARG}
		;;
		*)
			exit_abnormal
		;;
	esac
done

#-----------------------------------Make some verifications and modifications if needed

if [ "${URL}" = "" ]; then
	exit_abnormal
fi

verif_package(){
	hash ${1}
	if [ ${?} -ne 0 ]; then
		echo "${1} required"
		exit 1
	fi

}

verif_package "youtube-dl"
verif_package "ffmpeg"
verif_package "mid3v2"

if [ "${DEST}" = "" ] ; then
	DEST="."
fi
if [ "${ARTIST}" = "" ] ; then
	ARTIST="Inconnu"
fi
if [ "${ALBUM}" = "" ] ; then
	ALBUM="Inconnu"
fi
if [ "${GENRE}" = "" ] ; then
	GENRE="Inconnu"
fi
if [ "${YEAR}" = "" ] ; then
	YEAR="0000"
fi


#--------------------Create folder arborescence
cd ${DEST}
tree="${ARTIST}/${ALBUM}"
mkdir -p "${tree}"
cd "${tree}"

###--------------------------------Delete mp3
if [ $(ls -1 *.mp3 | wc -l) -ne 0 ]; then
	ls -lh 
	read -p "The program is going to remove all mp3 files in \"${DEST}/${tree}\" before downloading, are you sure ? (y/n) : " input 
	case ${input} in
		[yY])
	;;
 	*)
		 exit 0
	 ;;
	esac

	echo "Delete all mp3 files in folder..."
	rm -f *.mp3
fi

###--------------------------------------------------Download mp3 file(s)
echo "\nStart downloading music from url..."
youtube-dl -x --audio-format mp3 ${URL} -o '%(title)s.mp3'


###-------------------------------------------Rename file(s) and add cover image
for entry in *".mp3"
do
	filename=$(basename "${entry}")
	dest=$(echo ${filename} | tr ' ' '_')
	src="_${dest}"
	mv "${filename}" "${src}"
	if [ "${IMG}" != "" ]; then
		ffmpeg -i ${src} -i ${IMG} -map_metadata 0 -map 0 -map 1 ${dest}
	else
		mv "${src}" "${dest}"
	fi
	rm -f ${src}
	mid3v2 -a "${ARTIST}" -A "${ALBUM}" -g "${GENRE}" -y ${YEAR} ${dest}
done

