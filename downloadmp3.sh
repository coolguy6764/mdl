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
	echo "Usage: ${0} [OPTIONS] URL"
}

exit_abnormal(){
	usage
	exit 1
}

ARTIST=""
ALBUM=""
GENRE=""
YEAR=""
IMG=""
DEST=""

while getopts ":ha:A:g:y:i:d:" options; do
	case "${options}" in
		h)
			help
			exit 0
		;;
		a)
			ARTIST=${OPTARG}
			echo ${ARTIST}
		;;
		A)
			ALBUM=${OPTARG}
			echo ${ARTIST}
		;;
		g)
			GENRE=${OPTARG}
			echo ${ARTIST}
		;;
		y)
			YEAR=${OPTARG}
			echo ${ARTIST}
		;;
		i)
			IMG=${OPTARG}
			echo ${ARTIST}
		;;
		d)
			DEST=${OPTARG}
			echo ${ARTIST}
		;;
		*)
			exit_abnormal
		;;
	esac
done

exit 0

hash youtube-dl
if [ ${?} -ne 0 ]; then
	echo "youtube-dl required"
	exit -1
fi

hash ffmpeg
if [ ${?} -ne 0 ]; then
	echo "ffmpeg required"
	exit -1
fi

if [ ${#} -ne 3 ]; then 
	echo "You must pass the folder to download to, the image name and the youtube link to the script"
	exit -1
fi

dest_folder=${1}
image=${2}
url=${3}

echo "\ndestination folder: ${dest_folder}\ncover image: ${image}\nmp3 url: ${url}\n"

###--------------------------------Delete mp3
if [ $(ls -1 ${dest_folder}/*.mp3 | wc -l) -ne 0 ]; then
	ls -lh ${dest_folder}
	read -r -p "The program is going to remove all mp3 files before downloading, are you sure ? (y/n) : " input 
	case ${input} in
		[yY])
	;;
 	*)
		 echo "exit"
		 exit 0
	 ;;
	esac

	echo "Delete all mp3 files in folder..."
	rm -f ${dest_folder}/*.mp3
fi

###--------------------------------------------------Download audio
echo "\nStart downloading music from url..."
youtube-dl -x --audio-format mp3 ${url} -o  ${dest_folder}/'%(title)s.mp3'


###-------------------------------------------Rename and add cover image
for entry in "${dest_folder}"/*"mp3"
do
	filename=$(basename "${entry}")
	dest=$(echo ${filename} | tr ' ' '_')
	src="_${dest}"
	echo "\n${filename} will become ${dest} and have a cover image"
	mv "${dest_folder}/${filename}" "${dest_folder}/${src}"
	ffmpeg -i ${dest_folder}/${src} -i ${image} -map_metadata 0 -map 0 -map 1 ${dest_folder}/${dest}
	rm -f ${dest_folder}/${src}
done


