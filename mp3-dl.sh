#!/bin/sh
# shellcheck source=./utils.sh
#---------------------------------------------------------------------
#  _
# |_||aphaël
# | \\oy
# Git repo: https://github.com/rafutek
#
# Script to download music from YouTube, SoundCloud and other websites.
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
DEST_DIR=""
ALL_EXPR=""

artopt="0"
imgopt="0"

#---------------------------------------------------------------------
# Functions
#---------------------------------------------------------------------

# Error function: to call when a package is required
# Arguments: package required
required() {
    echo "'${1}' is required. Please run installer script." && exit 1
}

# Print usage and options to use
help_msg() {
	usage_msg
	echo "
OPTIONS:
	-h
            Print this help message and exit

	-i PATH
            Set the absolute path to the cover image (not compatible with -I)

	-I
            Extract the image from the website (not compatible with -i)

	-u
            Indicate the music/playlist address

	-e
            Extract the artist name from the title (title = \"artist - song\")

	-a \"Artist\"
            Set the artist name

	-A \"Album\"
            Set the album name

	-g \"Genre\"
            Set the genre name

	-y XXXX
            Set the year

	-d DIR
            Set the absolute path to the destination directory where to download the music

	-r \"exp\"
            Remove expression(s) in the video title to create the song name.
            Expression \" - \" is removed by default.
            Format: \"exp1/exp2/[...]/expN\" 
	"
}

# Print script usage
usage_msg() {
	echo "
USAGE: 
    $(basename "${0}") -u URL [OPTIONS]

DESCRIPTION: 
    mp3-dl is a script to download music from the web,
    store it where you want in a nice folder hierarchy,
    and add some metadata to the downloaded mp3 file(s)."
}

# Error function: print usage and exit
exit_abnormal(){
	error "$(usage_msg)" 
}

# Error function: to call when options are not compatible 
# arguments: options
sim_call() {
	printf "options "
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
		i=$((i+1))
	done
	error " are not callable simultaneously"
}

# Create folder arborescence
arbor() {
	cd "${DEST_DIR}" || error "Can not go to ${DEST_DIR}"
	tree="${ARTIST}/${ALBUM}"
	mkdir -p "${tree}"
	cd "${tree}" || error "Can not go to ${tree}"
}

# Download music as mp3
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
            
            # Remove expressions from each music title
            expressions="${ALL_EXPR}"
            if [ "${expressions}" != "" ]; then
                iterate=true
                while [ ${iterate} = true ]; do
                    case ${expressions} in
	            *"/"*)  ;;
	            *)      iterate=false;;
	            esac
        
                    exp=${expressions##*/}
	            expressions=${expressions%/*}
                    [ ${#exp} -gt 0 ] && newname=$( echo "${newname}" | sed "s/${exp}//gI" )
                done
            fi
            
            # Extract artist from title (if needed)
	    if [ "${artopt}" = "e" ];then
                case "${newname}" in
                *" - "*)    ARTIST=${newname%% - *} && newname=${newname#* - };;
		*)          [ "${ARTIST2}" != "" ] && echo "No artist to extract, using ${ARTIST2}" && ARTIST=${ARTIST2};;
                esac

                # Generate arborescence for the artist
		arbor
	    fi
	    
            # Remove separator and spaces from file name
	    newname=$( echo "${newname}" | sed "s/ - //g" )
	    dest=$( echo "${newname}" | sed "s/ //g; s/_//g" )
	    newname=$(echo "${newname%.mp3*}" | sed "s/_//g")

            # Override if music already downloaded 
            if [ -f "${dest}" ] && [ "${entry}" = "${dest}" ]; then
                rm -f "${entry}"
            else
                # Add cover image (if needed)
                src="_${dest}"
                if [ "${artopt}" = "e" ];then    
                    mv "${DEST_DIR}/${entry}" "${src}"
                else
                    mv "${entry}" "${src}"
                fi
	    	
	    	if [ "${IMG}" != "" ] && [ ! "${IMG}" = "extract-from-web" ]; then
		    ffmpeg -hide_banner -i "${src}" -i "${IMG}" -map 0 -c:a copy -map 1 -c:v copy "${dest}"
		else
		    mv "${src}" "${dest}"
		fi
		rm -f "${src}"

                # Add music information
		music_number=$((music_number+1))
		mid3v2 -t "${newname}" -a "${ARTIST}" -A "${ALBUM}" -g "${GENRE}" -y ${YEAR} -T "${music_number}" "${dest}"
	
                echo "" && echo "Created file: ${dest}"
                echo "	Title: ${newname}"
                echo "	Artist: ${ARTIST}"
                echo "	Album: ${ALBUM}"
                echo "	Genre: ${GENRE}"
                echo "	Year: ${YEAR}"

		if [ "${artopt}" = "e" ]; then
                    cd "${DEST_DIR}" || error "Can not go to ${DEST_DIR}"
	        fi
            fi
    done
}

#---------------------------------------------------------------------
# Script starts here
#---------------------------------------------------------------------

# Get different options
while getopts ":hea:A:g:y:Ii:d:u:r:" options; do
    case "${options}" in
    h)  help_msg && exit 0 ;;
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
    d)  DEST_DIR=${OPTARG};;	
    u)  URL=${OPTARG};;
    r)  ALL_EXPR=${OPTARG};;
    *)  exit_abnormal;;
    esac
done

# Check required packages
missing_do_ youtube-dl "required 'youtube-dl'"
missing_do_ ffmpeg "required 'ffmpeg'"
missing_do_ mid3v2 "required 'mid3v2'"

#msg=$(youtube-dl -U)
#[[ "${msg}" == *"ERROR"* ]] && error "youtube-dl must be updated with with 'youtube-dl -U'"


# Check music url 
[ "${URL}" = "" ] && exit_abnormal

# Set variables
[ "${DEST_DIR}" = "" ] && DEST_DIR="$(pwd)"
[ "${ARTIST}" = "" ] &&	ARTIST="Inconnu"
[ "${ALBUM}" = "" ] && ALBUM="Inconnu"
[ "${GENRE}" = "" ] && GENRE="Inconnu"
[ "${YEAR}" = "" ] && YEAR="0000"

# Main program
case ${artopt} in
	0 | a)  arbor && download && rename_plus_info;;
	e)      cd "${DEST_DIR}" || error "Can not go to ${DEST_DIR}"
		download && rename_plus_info;;
	esac

exit 0



