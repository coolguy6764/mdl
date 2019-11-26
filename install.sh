# Make downloadmp3 executable and place it in /usr/local/bin

#!/bin/bash

script="downloadmp3"
chmod +x "${script}.sh"
cp "${script}.sh" "/usr/local/bin/${script}.sh"
echo "${script} installé"
