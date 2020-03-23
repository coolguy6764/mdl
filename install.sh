#!/bin/sh
# Download dependent packages if they are missing,
# make mdl executable and place them in /usr/local/bin

BIN_PATH="/usr/local/bin"
SCRIPT="mdl"

trap 'error' INT

# Print an error message and exit
error() {
    echo "${1}" >&2; exit 1
}

# Set package manager for uninstallation
get_package_manager() {
    deb_based=false; arch_based=false
    command -v apt > /dev/null &&
        deb_based=true && package_manager=apt && return 0
    command -v pacman > /dev/null &&
        arch_based=true && package_manager=pacman && return 0
    error "No package manager known found"
}

get_install_package_option() {
    ${deb_based} && install_opt="install" && return 0
    ${arch_based} && install_opt="-S" && return 0
    error "package manager unset or unknown"
}

[ "$(id -u)" -ne 0 ] && error "Please run as root"

[ -f "${SCRIPT}.sh" ] || error "
${SCRIPT}.sh is not in the current directory,
please run the installer from the same directory"

get_package_manager
get_install_package_option

command -v ffmpeg > /dev/null || ${package_manager} ${install_opt} ffmpeg ||
    error "ffmpeg must be installed"

command -v mid3v2 > /dev/null || ${package_manager} ${install_opt} python-mutagen ||
    error "mid3v2 must be installed"

if ! command -v youtube-dl > /dev/null; then
    if ${arch_based}; then
       ${package_manager} ${install_opt} youtube-dl ||
           error "youtube-dl must be installed"

    elif ${deb_based}; then
        command -v curl > /dev/null || ${package_manager} ${install_opt} curl
        curl -L https://yt-dl.org/downloads/latest/youtube-dl -o ${BIN_PATH}/youtube-dl
        chmod a+rx ${BIN_PATH}/youtube-dl
    fi
fi

chmod +x ${SCRIPT}.sh &&
    cp ${SCRIPT}.sh ${BIN_PATH}/${SCRIPT} &&
    echo "${SCRIPT} is installed !" && exit

