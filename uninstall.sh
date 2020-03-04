#!/bin/bash
# Remove the executable mp3-dl from /usr/local/bin
# and ask to remove the packages that might have been installed
# shellcheck source=./utils.sh
ABS_PATH="$(realpath "$(dirname "${0}")")/"
. "${ABS_PATH}utils.sh"

be_root
trap_signals

path="/usr/local/bin/"
script="mp3-dl"

OS="$(get_OS)"
echo "Uninstalling on ${OS} based system..."

rm -f "${path}${script}" "${BIN_PATH}${script}-utils"
[ ! -f "${path}${script}" ] && [ ! -f "${BIN_PATH}${script}-utils" ] && 
    echo "${script} is uninstalled :("

printf "Do you want to remove dependent packages ? [y/n] " 
read -r choice
if [ "${choice}" = "y" ]; then
	echo "Removing dependent packages..."
	if [ "${OS}" = "${DEBIAN}" ]; then
		find / -name youtube-dl | sudo xargs rm -f
		[ "$(is_present "curl")" -eq 0 ] && apt remove curl
		[ "$(is_present "ffmpeg")" -eq 0 ] && apt remove ffmpeg
		[ "$(is_present "mid3v2")" -eq 0 ] && apt remove python-mutagen
	elif [ "${OS}" = "${ARCH}" ]; then
		[ "$(is_present "youtube-dl")" -eq 0 ] && pacman -R -s youtube-dl
		[ "$(is_present "ffmpeg")" -eq 0 ] && pacman -R -s ffmpeg
		[ "$(is_present "mid3v2")" -eq 0 ] && pacman -R -s python-mutagen
	fi
	echo "done"
fi


