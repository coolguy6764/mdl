#!/bin/bash
# shellcheck source=./utils.sh
#---------------------------------------------------------------------
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
# The script install.sh install those that are not present,
# and can be uninstalled with uninstall.sh.
#---------------------------------------------------------------------

#---------------------------------------------------------------------
# Variables 
#---------------------------------------------------------------------
BIN_PATH="/usr/local/bin/"

utils="$(basename "${0}")-utils"
if [ -f "${BIN_PATH}$utils" ]; then
     . "${utils}"
else
    required "${utils}"
fi

ctrl_C "program killed"

# Get options
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

#---------------------------------------------------------------------
# Functions
#---------------------------------------------------------------------
required() {
    echo "'${1}' is required. Please run installer script." && exit 1
}

help() {
	usage
	echo "
Options:
	-h          Print this help text and exit
	-i PATH     Set the absolute path to the cover image (not compatible with -I)
	-I          Extract the image from the website (not compatible with -i)
	-u          Indicate the music/playlist address
	-e          Extract the artist name from the title (title = \"artist - song\")
	-a \"Artist\"   Set the artist name
	-A \"Album\"    Set the album name
	-g \"Genre\"    Set the genre name
	-y XXXX     Set the year
	-d DIR      Set the absolute path to the destination directory where to download the music
	-r \"str\"  Remove expression(s) in the video title to create the song name.
                    It removes ' - ' by default.
                        Format: \"str1/str2/[...]/strN\" 
	"
}

usage() {
	echo "Usage: $(basename "${0}") -u URL [OPTIONS]"
}

exit_abnormal(){
	error "$(usage)" 
}

sim_call() {
	echo -n "options "
	i=0
	max=$(( ${#} - 1 ))
	for arg in "${@}"
	do
		case ${i} in
			0)      sep="";;
			${max}) sep=" and ";;
			*)      sep=", ";;
		esac
		echo "${sep}${arg}"
		(( i++ ))
	done
	error " are not callable simultaneously"
}

# Create folder arborescence
arbor() {
	cd "${DEST}" || error "Can not go to ${DEST}"
	tree="${ARTIST}/${ALBUM}"
	mkdir -p "${tree}"
	cd "${tree}" || error "Can not go to ${tree}"
}

# Ask and delete mp3 in current folder
#del_mp3() {
#	if [ "$(find . -maxdepth 1 -name '*.mp3*' | wc -l)" -ne 0 ]; then
#		ls -lh "*.mp3*" 
#                question="The program is going to remove all mp3 files in \"${DEST}/${tree}\" before downloading, are you sure ? [y/n]"
#                printf "%s" "${question}" 
#		read -r input 
#		[ "${input}" = "y" ] && echo "Delete all mp3 files in folder..." && rm -f "*.mp3*"
#	fi
#}

# Download audio and convert it to mp3
download() {
        echo "" && echo "Start downloading music from url..."
        if [ "${IMG}" = "extract-from-web" ]; then
            youtube-dl -i -x --audio-format mp3 --embed-thumbnail "${URL}" -o '%(title)s.%(ext)s'
        else
            youtube-dl -i -x --audio-format mp3 "${URL}" -o '%(title)s.%(ext)s'
        fi 
}

# Rename, add cover image and info to mp3 file(s)
rename_plus_info() {
    music_number=0
    for entry in *".mp3"; do
        
            newname="${entry}"
            for exp in "${exparray[@]}"; do
                [ ${#exp} -gt 0 ] && newname=$( echo "${newname}" | sed "s/${exp}//gI" )
            done

	    if [ "${artopt}" = "e" ];then
                case "${newname}" in
                *" - "*)    ARTIST=${newname%% - *} && newname=${newname#* - };;
		*)          [ "${ARTIST2}" != "" ] && echo "No artist to extract, using ${ARTIST2}" && ARTIST=${ARTIST2};;
                esac
		arbor
	    fi
		
	    newname=$( echo "${newname}" | sed "s/ - //g" )
	    dest=$( echo "${newname}" | sed "s/ //g; s/_//g" )
	    newname=$(echo ${newname%.mp3*} | sed "s/_//g")

            # Allow to override the output 
            if [ -f "${dest}" ] && [ "${entry}" = "${dest}" ]; then
                rm -f "${entry}"
            else
                # Rename file
                echo "" && echo "Create file: ${dest}"
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
	    	
	    	if [ "${IMG}" != "" ] && [ ${IMG} != "extract-from-web" ]; then
		    ffmpeg -hide_banner -i "${src}" -i "${IMG}" -map 0 -c:a copy -map 1 -c:v copy "${dest}"
		else
		    mv "${src}" "${dest}"
		fi
		
		rm -f "${src}"
		music_number=$((music_number+1))
		mid3v2 -t "${newname}" -a "${ARTIST}" -A "${ALBUM}" -g "${GENRE}" -y ${YEAR} -T "${music_number}" "${dest}"
	
		if [ "${artopt}" = "e" ]; then
                    cd "${DEST}" || error "Can not go to ${DEST}"
	        fi
            fi
    done
}


#---------------------------------------------------------------------
# Script starts here
#---------------------------------------------------------------------
while getopts ":hea:A:g:y:Ii:d:u:r:" options; do
    case "${options}" in
    h)  help && exit 0 ;;
    e)  [ "${artopt}" = "0" ] && artopt="e";;
    a)  if [ "${artopt}" = "0" ];then
            artopt="a"
    	    ARTIST=${OPTARG}
        else
    	    ARTIST2=${OPTARG}
        fi;;
    A)  ALBUM=${OPTARG};;
    g)  GENRE=${OPTARG};;
    y)  YEAR=${OPTARG};;
    i)  if [ "${imgopt}" = "0" ];then
            imgopt="i"
        else
            sim_call "${options}" "${imgopt}"
        fi
        IMG=${OPTARG};;
    I)  if [ "${imgopt}" = "0" ];then
    	    imgopt="I"
        else
    	    sim_call "${options}" "${imgopt}"
        fi
        IMG="extract-from-web";;
    d)  DEST=${OPTARG};;	
    u)  URL=${OPTARG};;
    r)  ALL_EXPR=${OPTARG};;
    *)  exit_abnormal;;
    esac
done

# Make some verifications and modifications if needed
[ "${URL}" = "" ] && exit_abnormal

missing_do_ youtube-dl "required 'youtube-dl'"
missing_do_ ffmpeg "required 'ffmpeg'"
missing_do_ mid3v2 "required 'mid3v2'"

msg=$(youtube-dl -U)
[[ "${msg}" == *"ERROR"* ]] && error "youtube-dl must be updated with with 'youtube-dl -U'"

[ "${DEST}" = "" ] && DEST="$(pwd)"
[ "${ARTIST}" = "" ] &&	ARTIST="Inconnu"
[ "${ALBUM}" = "" ] && ALBUM="Inconnu"
[ "${GENRE}" = "" ] && GENRE="Inconnu"
[ "${YEAR}" = "" ] && YEAR="0000"

# Create array of expressions to remove from file names
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

# Main program
case ${artopt} in
	0 | a)  arbor && download && rename_plus_info;;
	e)      cd "${DEST}" || error "Can not go to ${DEST}"
		download && rename_plus_info;;
	esac

exit 0



