# Download dependent packages if they are missing,
# make downloadmp3 executable and place it in /usr/local/bin

#!/bin/bash

error() {
	echo "${1}" >&2
	exit 1
}

trap "error 'installation stopped'" 2

missing_do_() {
	hash ${1}
	if [ ${?} -ne 0 ];then
		shift
		for cmd in "${@}"
		do
			eval ${cmd}
		done
	fi
}

install_curl="apt-get install curl"
install_ydl="missing_do_ curl '${install_curl}'; 
		curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl; 
		chmod a+rx /usr/local/bin/youtube-dl"
install_ffmpeg="apt-get install ffmpeg"
install_mid3v2="apt-get install python-mutagen"

echo -e "\nCheck for youtube-dl..."
missing_do_ youtube-dl "${install_ydl}"
youtube-dl -U

echo -e "\nCheck for ffmpeg..."
missing_do_ ffmpeg "${install_ffmpeg}"

echo -e "\nCheck for mid3v2..."
missing_do_ mid3v2 "${install_mid3v2}"


script="mp3-dl"
chmod +x "${script}.sh"
cp "${script}.sh" "/usr/local/bin/${script}"
if [ ${?} -eq 0 ];then
	echo -e "\n${script} installé"
fi
