# Remove the executable downloadmp3 from /usr/local/bin

#!/bin/bash

script="downloadmp3"
rm -f "/usr/local/bin/${script}"
echo "${script} désinstallé"
