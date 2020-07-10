#!/bin/sh

export BIN_PATH="/usr/local/bin"
export SCRIPT_NAME="mdl"

trap 'error' INT

error() {
    echo "${1}" >&2
    exit 1
}

run_as_root() {
    [ "$(id -u)" -eq "0" ] || error "Please run as root"
}

command_exists() {
    command -v "$1" >/dev/null
}

file_exists() {
    [ -f "$1" ] || error "$1 does not exist"
}

set_package_manager() {
    deb_based=false
    arch_based=false
    command_exists apt && deb_based=true && package_manager=apt && return 0
    command_exists pacman && arch_based=true && package_manager=pacman && return 0
    error "No package manager known found"
}

set_install_option() {
    ${deb_based} && install_opt="install -y" && return 0
    ${arch_based} && install_opt="-S" && return 0
    error "package manager unset or unknown"
}

set_uninstall_option() {
    ${deb_based} && uninstall_opt="remove" && return 0
    ${arch_based} && uninstall_opt="-Rs" && return 0
    error "package manager unset or unknown"
}

install() {
    command_exists "$1" ||
        ${package_manager} ${install_opt} "$1" ||
        error "$1 could not be installed"
}

uninstall() {
    ! command_exists "$1" && echo "$1 is not installed" && return 0
    ${package_manager} ${uninstall_opt} "$1"
    return 0
}

install_ydl() {
    command_exists youtube-dl && return 0
    install curl &&
        curl -L https://yt-dl.org/downloads/latest/youtube-dl -o $BIN_PATH/youtube-dl &&
        chmod a+rx $BIN_PATH/youtube-dl
}

uninstall_ydl() {
    rm $BIN_PATH/youtube-dl
    return 0
}
