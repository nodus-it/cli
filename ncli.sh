#/bin/bash
VERSION="v0.1"
REPO_PATH="nodus-it/cli"

parseValueFromJson()
{
	regex='"'"$1"'":\s"*\K[^\s,]*(?=\s*",)'
	echo `echo "$2" | grep -oP $regex`
}



checkForNewerVersion()
{
	json=$(curl https://api.github.com/repos/$REPO_PATH/releases/latest --silent)
	onlineVersion=$(parseValueFromJson "name" "$json")
	
	if [ "$onlineVersion" == "$VERSION" ]; then
		echo "Newest version installed"
	else
		echo "Update required ($onlineVersion available)"
		echo https://github.com/$REPO_PATH/releases/tag/$onlineVersion
	
		read -p "Would you update the script now? [yes] " update
		update=${update:-yes}
		if [ "$update" == "yes" ]; then
				filePath=$(pwd)"/"$(basename "$0")".test" # ToDo Remove Test
				curl -o $filePath https://raw.githubusercontent.com/$REPO_PATH/refs/tags/$onlineVersion/LICENCE
				echo "Please restart script...."
				exit 1;
		fi
	fi
}

checkForNewerVersion

############################################################################
#                                                                          #
#                               Functions                                  #
#                                                                          #
############################################################################

installDocker()
{
	info "Install docker..."
	return;
	apt update
	apt -y install apt-transport-https ca-certificates curl software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" -y
	apt -y install docker-ce docker-compose-plugin
}

updateSystem()
{
	apt update
	apt upgrade
}
