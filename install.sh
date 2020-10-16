#!/bin/bash

CURRENT_DIRECTORY=$(pwd)
echo "Current Directory: $CURRENT_DIRECTORY"

# install up2date common tools
# assume Ubuntu/debian
common_tools=("nmap" "git" "wireshark" "netcat" "john" "sqlmap")
sudo apt-get update && sudo apt-get upgrade && sudo apt autoremove & sudo apt autoclean
for i in "${common_tools[@]}"; do
	sudo apt-get install -y "${i}"
done

# sqlmap : git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev
# install msfconsole
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall
# wget burp suite and install it
wget https://portswigger.net/burp/releases/download?product=community&version=2020.9.2&type=Linux > burpInstall.sh && chmod 755 burpInstall.sh && ./burpInstall.sh

# reads lines from repos.list
while read line; do
	if [[ $line != "https://"* ]];
	then
		echo "Creating folder [$line]"
		# create a folder for WINDOWS, LINUX, etc titles found in repos.list
		if [ $CURRENT_DIRECTORY = $(pwd) ]
		then
			mkdir $line
			cd $line
		else
			mkdir ../$line
			cd ../$line
		fi
	else
		echo "Cloning $line"
		git clone $line
		echo ""
	fi
done < repos.list