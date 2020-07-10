#!/bin/sh
# Download dependent packages if needed
# and copy script to /usr/local/bin
. ./common.sh &&
    run_as_root &&
    file_exists "${SCRIPT_NAME}.sh" &&
    set_package_manager &&
    set_install_option &&
    install_ydl &&
    install flac &&
    chmod +x "${SCRIPT_NAME}.sh" &&
    cp -v "${SCRIPT_NAME}.sh" "${BIN_PATH}/${SCRIPT_NAME}" &&
    echo "${SCRIPT_NAME} is installed"