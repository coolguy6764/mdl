#!/bin/sh
# Download dependent packages if they are missing,
# make downloadmp3 executable and place it in /usr/local/bin

if [ "$(id -u)" -ne 0 ] ; then 
	echo "Please run as root"  
	exit 1 
fi

trap "error 'installation stopped'" 2

error() {
	echo "${1}" >&2
	exit 1
}

missing_do_() {
	if [ "$(is_present "${1}")" -eq 1 ] ; then
		shift
		for cmd in "${@}"
		do
			eval "${cmd}"
		done
	fi
}

is_present() {
	if command -v "${1}" >"/dev/null"; then
		echo 0
	else
		echo 1
	fi
}

ARCH="Arch"
DEBIAN="Debian"

[ "${OS}" = "" ] && [ "$(is_present "pacman")" -eq 0 ] && 
	OS="${ARCH}"
[ "${OS}" = "" ] && [ "$(is_present "apt")" -eq 0 ] && 
	OS="${DEBIAN}"
[ "${OS}" = "" ] && error "Sorry, this script works only for Arch and Debian based systems... "

echo "Installing on ${OS} based system..."
if [ "${OS}" = "${DEBIAN}" ]; then
	install_curl="apt-get install curl"
	install_ydl="missing_do_ curl '${install_curl}'; 
		curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl; 
		chmod a+rx /usr/local/bin/youtube-dl"
	install_ffmpeg="apt-get install ffmpeg"
	install_mid3v2="apt-get install python-mutagen"

elif [ "${OS}" = "${ARCH}" ]; then 
		install_ydl="pacman -Syu; 
					pacman -S youtube-dl"
	install_ffmpeg="pacman -S ffmpeg"
	install_mid3v2="pacman -S python-mutagen"
fi

echo "Checking for youtube-dl..."
missing_do_ youtube-dl "${install_ydl}"

echo "Checking for ffmpeg..."
missing_do_ ffmpeg "${install_ffmpeg}"

echo "Checking for mid3v2..."
missing_do_ mid3v2 "${install_mid3v2}"


script="mp3-dl"
chmod +x "${script}.sh"
cp "${script}.sh" "/usr/local/bin/${script}"
[ -f "/usr/local/bin/${script}" ] && echo "${script} is installed !"
