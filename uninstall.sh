# Remove the executable downloadmp3 from /usr/local/bin
# and ask to remove the packages that might have been installed

#!/bin/bash

error() {
        echo "${1}" >&2
        exit 1
}

trap "error 'uninstall stopped'" 2

rem=false
ask_rm() {
 	echo -ne "\n${1} is installed, do you want to remove it? [y/n] : " 
	read -n1 input
	echo
	case ${input} in
		[yY])
			rem=true
			;;
		*)
			rem=false
			;;
	esac
}

present_do_() {
        hash ${1}
        if [ ${?} -eq 0 ];then
                shift
                for cmd in "${@}"
                do
                        eval ${cmd}
                done
        fi
}

present_do_ youtube-dl "ask_rm youtube_dl"
if [ ${rem} = true ]; then
	find / -name youtube-dl | sudo xargs rm
fi

present_do_ ffmpeg "ask_rm ffmpeg"
if [ ${rem} = true ]; then
	apt-get -y remove ffmpeg 
fi

present_do_ mid3v2 "ask_rm mid3v2"
if [ ${rem} = true ]; then
	apt-get -y remove python-mutagen 
fi


script="downloadmp3"
rm -f "/usr/local/bin/${script}"
if [ ${?} -eq 0 ];then
	echo "${script} désinstallé"
fi
