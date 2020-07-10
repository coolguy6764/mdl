#!/bin/sh
# Remove the executable mdl from /usr/local/bin
# and ask to remove dependent packages
. ./common.sh &&
    run_as_root &&
    file_exists "${BIN_PATH}/${SCRIPT_NAME}" &&
    rm -v "${BIN_PATH}/${SCRIPT_NAME}" &&
    printf "
Do you want to remove dependent packages ?
You will be asked for confirmation for each package.
[y/n] " &&
    read -r choice &&
    [ "${choice}" = "y" ] &&
    set_package_manager &&
    set_uninstall_option &&
    uninstall_ydl &&
    uninstall flac

echo "${SCRIPT_NAME} is unistalled"
