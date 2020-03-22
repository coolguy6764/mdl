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
LANG="fr"
artist=""
album=""
genre=""
year=""
cover=""
dest_directory=""
all_expressions=""
extract_artist=false
artist_opt=false
cover_opt=false
extract_cover=false
scriptname="$(basename "${0}" | sed "s/.sh$//")"
tempdir="temp"

#---------------------------------------------------------------------
# Functions
#---------------------------------------------------------------------

# Error function: to call when a package is required
# Arguments: package required
required() {
    echo "'${1}' is required. Please run installer script." && exit 1
}

utils="${scriptname}-utils"
if [ -f "${BIN_PATH}$utils" ]; then
     . "${utils}"
else
    required "${utils}"
fi

ctrl_C "program killed"


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
    ${scriptname} [OPTIONS] URL

DESCRIPTION: 
    mdl is a utility to download music from the web,
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
    printf "Options "
    i=0
    max=$(( ${#} - 1 ))
    for arg in "${@}"
    do
	    case ${i} in
		    0)      sep="";;
		    ${max}) sep=" and ";;
		    *)      sep=", ";;
	    esac
	    printf "${sep}${arg}"
	    i=$((i+1))
    done
    error " are not callable simultaneously"
}

# Go to the wanted directory if not already there
goto() {
    [ "$(basename "$(pwd)")" = "$(basename "${1}")" ] || 
        cd "${1}" || return 1
}

# Create temporary directory if not already created
create_tempdir() {
    actualdir="$(pwd)"
    goto "${dest_directory}" && [ ! -d "${tempdir}" ] && 
        mkdir "${tempdir}" && cd "${actualdir}" || return 1
}

# Delete temporary directory if present
del_tempdir() {
    actualdir="$(pwd)"
    goto "${dest_directory}" && [ -d "${tempdir}" ] && rm -r "${tempdir}" || return 1
    if [ ! "$(basename ${actualdir})" = "${tempdir}" ]; then
       cd "${actualdir}" || return 1
    fi
}

# Download music as mp3
download() { 
    actualdir="$(pwd)"
    goto "${tempdir}" || return 1
    
    echo "" && echo "Start downloading music from url..."
    [ "${cover}" = "extract-from-web" ] && opt=--embed-thumbnail

    youtube-dl -i -x --audio-format mp3 ${opt} "${URL}" -o "%(title)s.%(ext)s" && 
       cd "${actualdir}" || return 1
}

# Take every mp3 file in temporary directory,
# remove unwanted expressions, get music info,
# rename, add cover and metadata to the files and
# put them in their folder hierarchy
manage_tempfiles() {
    actualdir="$(pwd)"
    goto "${tempdir}" && ls ./*.mp3* > /dev/null || return 1
    
    music_number=1
    for filename in *".mp3"; do
        actual_filename="${filename}"
        remove_expressions &&
            extract_artist &&
            extract_title &&
            clear_filename &&
            rename_file &&
            add_cover &&
            add_metadata &&
            move_file || return 1
        music_number=$((music_number+1))
    done
    cd "${actualdir}" || return 1
}

# Remove unwanteed expressions from music filename
remove_expressions() {
    expressions="${all_expressions}"
    if [ "${expressions}" != "" ]; then
        [ -z "${filename}" ] && return 1 # variable filename must be non-zero
        newname="${filename}"
        iterate=true

        while [ ${iterate} = true ]; do
            # Iterate while expressions string contains a / character
            echo "${expressions}" | grep / > /dev/null || iterate=false
            
            # Get expression before the / character
            exp=${expressions##*/}

            # Keep the expressions after the / character
	    expressions=${expressions%/*}

            # Remove the expression from the filename
            [ ${#exp} -gt 0 ] && 
                newname="$(echo "${newname}" | sed "s/${exp}//gI")"
        done
        filename="${newname}"
    fi
}

# Extract artist from the title if needed
extract_artist() {
    if [ ${extract_artist} = true ]; then
        [ -z "${filename}" ] && return 1 # variable filename must be non-zero
        echo "${filename}" | grep " - " > /dev/null && 
            artist=${filename%% - *} && 
            filename="$(echo "${filename}" | sed "s/${artist}//")"
    fi
    return 0
}

extract_title() {
    [ -z "${filename}" ] && return 1 # variable filename must be non-zero
    # Remove artist separator, spaces before and after the title and file extension
    title="$(echo "${filename}" | sed "s/\s-\s//; s/\s*\<//; s/\s*$//; s/.mp3$//")"
    filename="${title}.mp3"
    return 0
}

# Remove uneeded characters
clear_filename() {
    [ -z "${filename}" ] && return 1 # variable filename must be non-zero
    
    # Remove separator - and spaces before and after the filename
    noext="$(echo "${filename}" | sed "s/.mp3//")"
    filename="$(echo "${noext}" | sed "s/\s//g").mp3"
    return 0
}

rename_file() {
    # The actual file must be present and its new name non-zero
    [ -f "${actual_filename}" ] && [ -z "${filename}" ] && return 1
    if [ ! "${actual_filename}" = "${filename}" ]; then
        mv "${actual_filename}" "${filename}" || return 1
    fi
    return 0
}

add_cover() {
    [ -f "${filename}" ] || return 1 # filename must be present
    if [ "${cover_opt}" = true ]; then
        [ ! -z ${cover} ] && temp_file="_${filename}" &&
            ffmpeg -hide_banner -i "${filename}" -i "${cover}" \
            -map 0 -c:a copy -map 1 -c:v copy "${temp_file}" &&
            rm "${filename}" && mv "${temp_file}" "${filename}" || return 1
    fi
    return 0
}

# Add album, artist, year, genre and image if wanted
add_metadata() {
    [ -f "${filename}" ] &&
        mid3v2 -T "${music_number}" -t "${title}" -a "${artist}"\
        -A "${album}" -g "${genre}" -y ${year} "${filename}" &&
        echo "Added metadata to ${filename}:" &&
        echo "  num: ${music_number}" &&
        echo "  title: ${title}" &&
        echo "  artist: ${artist}" &&
        echo "  album: ${album}" &&
        echo "  genre: ${genre}" &&
        echo "  year: ${year}" || return 1
}

# Place file in appropriate directory
move_file() {
    actualdir="$(pwd)"
    goto "${dest_directory}" &&
        [ -f "${tempdir}/${filename}" ] &&
        hierarchy="${artist}/${album}" &&
        mkdir -p "${hierarchy}" &&
        mv -f "${tempdir}/${filename}" "${hierarchy}/${filename}" || return 1

    cd "${actualdir}" || return 1
}

#---------------------------------------------------------------------
# Script starts here
#---------------------------------------------------------------------

# Get different options
while getopts ":hea:A:g:y:Ii:d:r:" options; do
    case "${options}" in
    h)  help_msg && exit 0;;
    e)  extract_artist=true;;
    a)  artist_opt=true && artist=${OPTARG};;
    A)  album=${OPTARG};;
    g)  genre=${OPTARG};;
    y)  year=${OPTARG};;
    i)  if [ "${extract_cover}" = false ];then
            cover_opt=true
        else
            sim_call "${options}" "I"
        fi
        cover=${OPTARG};;
    I) if [ "${cover_opt}" = false ];then
    	    extract_cover=true
        else
    	    sim_call "${options}" "i"
        fi
        cover="extract-from-web";;
    d)  dest_directory=${OPTARG};;	
    r)  all_expressions=${OPTARG};;
    *)  exit_abnormal;;
    esac
done


# Check music url 
for last in "$@"; do :; done
URL="${last}"
[ "${URL}" = "" ] && exit_abnormal

# Set variables
[ "${dest_directory}" = "" ] && dest_directory="$(pwd)"
[ "${LANG}" = "fr" ] && unknown="Inconnu" || unknown="Unknown"
[ "${artist}" = "" ] &&	artist="${unknown}" # will be overwritten by extraction if there is
[ "${album}" = "" ] && album="${unknown}"
[ "${genre}" = "" ] && genre="${unknown}"
[ "${year}" = "" ] && year="0000"

# Check required packages
missing_do_ youtube-dl "required 'youtube-dl'"
missing_do_ ffmpeg "required 'ffmpeg'"
missing_do_ mid3v2 "required 'mid3v2'"

del_tempdir 

create_tempdir && 
    download && 
    manage_tempfiles || echo "Runtime error" >&2

del_tempdir

# # Main program
# case ${artopt} in
# 	0 | a)  arbor && download && rename_plus_info;;
# 	e)      cd "${dest_directory}" || error "Can not go to ${dest_directory}"
# 		download && rename_plus_info;;
# 	esac

# exit 0



