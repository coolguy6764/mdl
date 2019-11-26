# Make downloadmp3 executable and place it in /usr/local/bin

#!/bin/bash

chmod +x downloadmp3
cp downloadmp3 /usr/local/bin

cd ~
shname="$(pwd)/.$(basename ${SHELL})rc" 
echo ${shname}
. ${shname} # syntax error
