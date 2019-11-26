# Make downloadmp3 executable and place it in /usr/local/bin

#!/bin/bash

chmod +x downloadmp3.sh
cp downloadmp3.sh /usr/local/bin/downloadmp3

cd ~
shname="$(pwd)/.$(basename ${SHELL})rc" 
echo ${shname}
. ${shname} # syntax error
