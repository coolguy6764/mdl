#!/bin/sh
# Remove the executable mdl from /usr/local/bin
# and ask to remove the packages that might have been installed

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

get_rm_package_option() {
    ${deb_based} && rm_opt="remove" && return 0
    ${arch_based} && rm_opt="-Rs" && return 0
    error "package manager unset or unknown"
}

[ "$(id -u)" -ne 0 ] && error "Please run as root"

[ -f "${BIN_PATH}/${SCRIPT}" ] && rm "${BIN_PATH}/${SCRIPT}"
[ -f "${BIN_PATH}/${SCRIPT}" ] || echo "${SCRIPT} is uninstalled :("

printf "
Do you want to remove dependent packages ?
You will be asked for confirmation for each package.
[y/n] "
read -r choice
if [ "${choice}" = "y" ]; then
    echo "Removing dependent packages..."
    get_package_manager &&
        get_rm_package_option &&
        echo "Uninstalling with ${package_manager}..."
    command -v curl > /dev/null && ${package_manager} ${rm_opt} curl
    command -v ffmpeg > /dev/null && ${package_manager} ${rm_opt} ffmpeg
    command -v mid3v2 > /dev/null && ${package_manager} ${rm_opt} python-mutagen
    if command -v youtube-dl > /dev/null; then
        ${deb_based} && find / -name youtube-dl | sudo xargs rm -f
        ${arch_based} && ${package_manager} ${rm_opt} youtube-dl
    fi
fi

echo "Done" && exit

