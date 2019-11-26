# Remove the executable downloadmp3 from /usr/local/bin

#!/bin/bash
rm -f /usr/local/bin/downloadmp3

cd ~
shname="$(pwd)/.$(basename ${SHELL})rc" 
echo ${shname}
. ${shname} # syntax error
