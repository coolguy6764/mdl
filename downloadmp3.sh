# Script qui télécharge l'audio d'une ou plusieurs vidéos en format mp3
# selon l'aborescence:
#	Dossier
#	└── Artiste
#	    └── Album
#	        └── titre1.mp3
#	        └── ... 
# Plusieurs options permettent d'entrer des informations au(x) mp3 comme 
# le nom d'artiste, d'album, le genre, la date ou encore une image de couverture

# /!\ Attention /!\ 
# Les paquets utilisés sont:
#	youtube-dl (téléchargement des mp3)
#	ffmpeg (inclusion de l'image aux mp3)
#	mid3v2 (inclusion d'informations supplémentaires: album, artiste, année, etc.. )
# Veiller à les installer avant toute chose


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
			Set the destination directory to create the arborescence and download the mp3 file(s)	
	-r \"exp1/exp2/[...]/expn\"
			Indicate the expressions to remove in the video title to create the song name
			(remove ' - ' by default)

Warnings:
	> This script must be executed in a bash shell
	> Image and url are required
	> Paths must not contain spaces
	"
}

usage() {
	echo "Usage: ${0} [OPTIONS] -i /absolute/path/image -u URL"
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
ALL_EXPR=""

while getopts ":ha:A:g:y:i:d:u:r:" options; do
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
		r)
			ALL_EXPR=${OPTARG}
			;;
		*)
			exit_abnormal
			;;
	esac
done


#-----------------------------------Make some verifications and modifications if needed

if [ "${URL}" = "" ] || [ "${IMG}" = "" ]; then
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

#----------------------------------Create array of expressions to remove from files
if [ "${ALL_EXP}" = "" ] ; then
	exparray=()
	iterate=true
	while [ ${iterate} = true ]
	do
		case ${ALL_EXPR} in
			*"/"*)
				;;
			*)
				iterate=false
				;;
		esac

		exp=${ALL_EXPR##*/}
		ALL_EXPR=${ALL_EXPR%/*}
		exparray+=("${exp}")
	done
fi


#----------------------------Create folder arborescence
cd ${DEST}
tree="${ARTIST}/${ALBUM}"
mkdir -p "${tree}"
cd "${tree}"

###-------------------------------------------Delete mp3
if [ $(ls -1 *.mp3 | wc -l) -ne 0 ]; then
	ls -lh 
	read -n1 -p "The program is going to remove all mp3 files in \"${DEST}/${tree}\" before downloading, are you sure ? (y/n) : " input 
	case ${input} in
		[yY])
	;;
 	*)
		 exit 0
	;;
	esac

	echo -e "\n\rDelete all mp3 files in folder..."
	rm -f *.mp3
fi

###--------------------------------------------------Download mp3 file(s)
echo -e "\nStart downloading music from url..."
youtube-dl -x --audio-format mp3 ${URL} -o '%(title)s.mp3'


###-------------------------------------------Rename file(s) and add cover image
i=0
for entry in *".mp3"
do

	newname="${entry}"
	for exp in "${exparray[@]}"
	do
		if [ ${#exp} -gt 0 ]; then
			newname=$( echo "${newname}" | sed "s/${exp}//gI" )
		fi
	done
	
	newname=$( echo "${newname}" | sed "s/ - //g" )
	dest=$( echo "${newname}" | sed "s/ /_/g" )
	echo "new name: ${newname}, dest name: ${dest}"

	src="_${dest}"
	mv "${entry}" "${src}"
	ffmpeg -i ${src} -i "${IMG}" -map_metadata 0 -map 0 -map 1 ${dest}
	rm -f ${src}
	i=$((i+1))
	mid3v2 -a "${ARTIST}" -A "${ALBUM}" -g "${GENRE}" -y ${YEAR} -T "${i}" ${dest}
done


