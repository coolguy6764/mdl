#!/bin/sh

BIN_PATH="/usr/local/bin/"
ARCH="Arch"
DEBIAN="Debian"

be_root() {
	[ "$(id -u)" -ne 0 ] && 
		echo "Please run as root"  &&
		exit 1
}

ctrl_C() {
	trap "error '${1}'" 2
}
error() {
	echo "${1}" >&2
	exit 1
}

get_OS() {
	OS=""
	[ "${OS}" = "" ] && [ "$(is_present "pacman")" -eq 0 ] && OS="${ARCH}"
	[ "${OS}" = "" ] && [ "$(is_present "apt")" -eq 0 ] && OS="${DEBIAN}"
	[ "${OS}" = "" ] && error "Sorry, this script works only for Arch and Debian based systems... "
	echo "${OS}"
}

missing_do_() {
	echo "Checking for ${1}..."
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


