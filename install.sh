#!/bin/sh
# Download dependent packages if they are missing,
# make mp3-dl executable (and it's dependent utils script)
#  and place them in /usr/local/bin

# shellcheck source=./utils.sh
ABS_PATH="$(realpath "$(dirname "${0}")")/"
. "${ABS_PATH}utils.sh"

be_root
trap_signals

OS="$(get_OS)"
echo "Installing on ${OS} based system..."
if [ "${OS}" = "${DEBIAN}" ]; then
	install_curl="apt install curl"
	install_ydl="missing_do_ curl '${install_curl}'&&
	 curl -L https://yt-dl.org/downloads/latest/youtube-dl -o ${BIN_PATH}youtube-dl &&
	 chmod a+rx /usr/local/bin/youtube-dl"
	install_ffmpeg="apt install ffmpeg"
	install_mid3v2="apt install python-mutagen"

elif [ "${OS}" = "${ARCH}" ]; then 
	install_ydl="pacman -Syu && pacman -S --needed youtube-dl"
	install_ffmpeg="pacman -S --needed ffmpeg"
	install_mid3v2="pacman -S --needed python-mutagen"
fi

missing_do_ youtube-dl "${install_ydl}"
missing_do_ ffmpeg "${install_ffmpeg}"
missing_do_ mid3v2 "${install_mid3v2}"


script="mp3-dl"
chmod +x "${ABS_PATH}${script}.sh" "${ABS_PATH}utils.sh" 
cp "${ABS_PATH}${script}.sh" "${BIN_PATH}${script}"
cp "${ABS_PATH}utils.sh" "${BIN_PATH}${script}-utils"
[ -f "${BIN_PATH}${script}" ] && [ -f "${BIN_PATH}${script}-utils" ] && 
    echo "${script} is installed !"
