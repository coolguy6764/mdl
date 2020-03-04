#!/bin/bash
#----------------------------------------------------------------------------------------
#  _
# |_||aphaël
# | \\oy
# Git repo: https://framagit.org/linur
#
# Script to download music from YouTube, SoundCloud and other websites.
# It store them as below:
#	Folder
#	└── Artist
#	    └── Album
#	        └── title.mp3
# 
# Some options allow you to add information to the musics,
# like artist name, album name, genre and date.
# An image can also be integrated to the music like an album cover.
# Moreover removing expressions is doable.
#
# /!\ Warning /!\
# The used packages are:
#	youtube-dl (audio download)
#	ffmpeg (image integration)
#	mid3v2 (add information: album, artist, genre, year)
#
# The script install.sh install those that are not present,
# and can be uninstalled with uninstall.sh.
#----------------------------------------------------------------------------------------
# shellcheck source=./utils.sh
ABS_PATH="$(realpath "$(dirname "${0}")")/"
. "${ABS_PATH}"utils.sh

trap_signals

help() {
	usage
	echo "
Options:
	-h		Print this help text and exit
	-i /absolute/path/to/image
			Set the cover image (not compatible with -I)
	-I		Extract the image from the website (not compatible with -i)
	-u		Indicate the music/playlist address
	-e 		Extract the artist name (use it if music title is \"artist - song\")
	-a \"Artist\"	Set the artist name
	-A \"Album\"	Set the album name
	-g \"Genre\"	Set the genre name
	-y XXXX		Set the year
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
	echo "Usage: $(basename ${0}) -u URL [OPTIONS]"
}

exit_abnormal(){
	error "$(usage)" 
}

sim_call() {
	echo -n "options "
	i=0
	max=$(expr ${#} - 1)
	for arg in ${@}
	do
		case ${i} in
			0) sep="";;
			${max}) sep=" and ";;
			*) sep=", ";;
		esac
		echo -n "${sep}${arg}"
		let "i++"
	done
	error " are not callable simultaneously"
}


#-----------------------Get options

ARTIST=""
ARTIST2=""
ALBUM=""
GENRE=""
YEAR=""
IMG=""
DEST=""
ALL_EXPR=""

artopt="0"
imgopt="0"
while getopts ":hea:A:g:y:Ii:d:u:r:" options; do
	case "${options}" in
		h)
			help
			exit 0
			;;
		e)
			[ "${artopt}" = "0" ] && artopt="e"
			;;
		a)
			if [ "${artopt}" = "0" ];then
				artopt="a"
				ARTIST=${OPTARG}
			else
				ARTIST2=${OPTARG}
			fi
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
			if [ "${imgopt}" = "0" ];then
				imgopt="i"
			else
				sim_call ${options} ${imgopt}
			fi
			IMG=${OPTARG}
			;;
		I)
			if [ "${imgopt}" = "0" ];then
				imgopt="I"
			else
				sim_call ${options} ${imgopt}
			fi
			IMG=1
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


#----------------------------------Make some verifications and modifications if needed

[ "${URL}" = "" ] && exit_abnormal


verif_package(){
	hash ${1}
	if [ ${?} -ne 0 ]; then
		error "${1} required"
	fi
}

verif_package "youtube-dl"
verif_package "ffmpeg"
verif_package "mid3v2"


msg=$(youtube-dl -U)
[[ "${msg}" == *"ERROR"* ]] && error "youtube-dl must be updated with install.sh, or with the command : youtube-dl -U "

[ "${DEST}" = "" ] && DEST="$(pwd)"
[ "${ARTIST}" = "" ] &&	ARTIST="Inconnu"
[ "${ALBUM}" = "" ] && ALBUM="Inconnu"
[ "${GENRE}" = "" ] && GENRE="Inconnu"
[ "${YEAR}" = "" ] && YEAR="0000"

#----------------------------------Create array of expressions to remove from files
if [ "${ALL_EXPR}" != "" ] ; then
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



arbor() {
	#----------------------------Create folder arborescence
	cd ${DEST}
	tree="${ARTIST}/${ALBUM}"
	mkdir -p "${tree}"
	cd "${tree}"
}

del_mp3() {
	#-------------------------------------------Delete mp3
	if [ $(ls -1 *.mp3 | wc -l) -ne 0 ]; then
		ls -lh *.mp3 
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
}

dl() {
	#--------------------------------------------Download audio and convert it to mp3
	echo -e "\nStart downloading music from url..."
	YOPT=""
	[[ ${IMG} == 1 ]] && YOPT="--embed-thumbnail"
	youtube-dl -i -x --audio-format mp3 ${YOPT} ${URL} -o '%(title)s.%(ext)s'
}


rn_info() {
	#------------------------Rename, add cover image and info to mp3 file(s)
	i=0
	for entry in *".mp3"
	do
		newname="${entry}"
		for exp in "${exparray[@]}"
		do
			[ ${#exp} -gt 0 ] && newname=$( echo "${newname}" | sed "s/${exp}//gI" )
		done

		if [ "${artopt}" = "e" ];then
			case "${newname}" in
				*" - "*) 
					ARTIST=${newname%% - *}
					newname=${newname#* - }
					;;
				*)
					[ "${ARTIST2}" != "" ] && ARTIST=${ARTIST2}
					echo "No artist to extract, using ${ARTIST}"
					;;
			esac
			arbor
		fi
		
		
		newname=$( echo "${newname}" | sed "s/ - //g" )
		dest=$( echo "${newname}" | sed "s/ //g; s/_//g" )
		newname=$(echo ${newname%.mp3*} | sed "s/_//g")
		echo -e "\nCreate file: ${dest}"
		echo "	Title: ${newname}"
		echo "	Artist: ${ARTIST}"
		echo "	Album: ${ALBUM}"
		echo "	Genre: ${GENRE}"
		echo "	Year: ${YEAR}"
		src="_${dest}"

		if [ "${artopt}" = "e" ];then
			mv "${DEST}/${entry}" "${src}"
		else
			mv "${entry}" "${src}"
		fi
		
		if [ "${IMG}" != "" ] && [ ${IMG} != 1 ]; then
			ffmpeg -hide_banner -i ${src} -i "${IMG}" -map 0 -c:a copy -map 1 -c:v copy ${dest}
		else
			mv "${src}" "${dest}"
		fi
		
		rm -f ${src}
		i=$((i+1))
		mid3v2 -t "${newname}" -a "${ARTIST}" -A "${ALBUM}" -g "${GENRE}" -y ${YEAR} -T "${i}" ${dest}
	
		[ "${artopt}" = "e" ] && cd ${DEST}
	done
}


case ${artopt} in
	0 | a)
		arbor
		dl
		rn_info
		;;
	e)
		cd ${DEST}
		dl
		rn_info
		;;
	esac

exit 0



