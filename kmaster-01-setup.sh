#!/bin/bash

echo '.'
echo '.'
echo ' /$$$$$$$$ /$$$$$$ /$$$$$$$   /$$$$$$           /$$$$$$  /$$$$$$$$      /$$      /$$ /$$$$$$ /$$   /$$ /$$$$$$$$'
echo '|__  $$__/|_  $$_/| $$__  $$ /$$__  $$         /$$__  $$| $$_____/     | $$$    /$$$|_  $$_/| $$$ | $$| $$_____/'
echo '   | $$     | $$  | $$  \ $$| $$  \__/        | $$  \ $$| $$           | $$$$  /$$$$  | $$  | $$$$| $$| $$      '
echo '   | $$     | $$  | $$$$$$$/|  $$$$$$  /$$$$$$| $$  | $$| $$$$$ /$$$$$$| $$ $$/$$ $$  | $$  | $$ $$ $$| $$$$$   '
echo '   | $$     | $$  | $$$$$$$/|  $$$$$$  /$$$$$$| $$  | $$| $$$$$ /$$$$$$| $$ $$/$$ $$  | $$  | $$ $$ $$| $$$$$   '
echo '   | $$     | $$  | $$____/  \____  $$|______/| $$  | $$| $$__/|______/| $$  $$$| $$  | $$  | $$  $$$$| $$__/   '
echo '   | $$     | $$  | $$       /$$  \ $$        | $$  | $$| $$           | $$\  $ | $$  | $$  | $$\  $$$| $$      '
echo '   | $$    /$$$$$$| $$      |  $$$$$$/        |  $$$$$$/| $$           | $$ \/  | $$ /$$$$$$| $$ \  $$| $$$$$$$$'
echo '   |__/   |______/|__/       \______/          \______/ |__/           |__/     |__/|______/|__/  \__/|________/'
echo '.'
echo '.'
echo ' /$$$$$$$  /$$         /$$   /$$ /$$   /$$ /$$$$$$$  /$$$$$$$$'
echo '| $$__  $$|__/        | $$  /$$/| $$  | $$| $$__  $$| $$_____/'
echo '| $$  \ $$ /$$        | $$ /$$/ | $$  | $$| $$  \ $$| $$'
echo '| $$$$$$$/| $$ /$$$$$$| $$$$$/  | $$  | $$| $$$$$$$ | $$$$$'
echo '| $$____/ | $$|______/| $$  $$  | $$  | $$| $$__  $$| $$__/'
echo '| $$      | $$        | $$\  $$ | $$  | $$| $$  \ $$| $$'
echo '| $$      | $$        | $$ \  $$|  $$$$$$/| $$$$$$$/| $$$$$$$$'
echo '|__/      |__/        |__/  \__/ \______/ |_______/ |________/'
echo '.'
echo '.'

# Determine OS platform
UNAME=$(uname | tr "[:upper:]" "[:lower:]")

# If Linux, try to determine specific distribution
if [[ "$UNAME" == "linux" ]]; then
	# If available, use LSB to identify distribution
	if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
		export DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)

        # Otherwise, use release info file
	else
		export DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
	fi
fi

# For everything else (or if above failed), just use generic identifier
[ "$DISTRO" == "" ] && export DISTRO=$UNAME
unset UNAME
echo "#$DISTRO#"

if [[ $DISTRO == debian* ]]; then

	echo '.'
	echo '       /$$           /$$       /$$'
	echo '      | $$          | $$      |__/'
	echo '  /$$$$$$$  /$$$$$$ | $$$$$$$  /$$  /$$$$$$  /$$$$$$$'
	echo ' /$$__  $$ /$$__  $$| $$__  $$| $$ |____  $$| $$__  $$'
	echo '| $$  | $$| $$$$$$$$| $$  \ $$| $$  /$$$$$$$| $$  \ $$'
	echo '| $$  | $$| $$_____/| $$  | $$| $$ /$$__  $$| $$  | $$'
	echo '|  $$$$$$$|  $$$$$$$| $$$$$$$/| $$|  $$$$$$$| $$  | $$'
 	echo '\_______/ \_______/|_______/ |__/ \_______/|__/  |__/'
	echo '.'

	echo '.'
	echo '**********************'
	echo '* Parametrage'
	echo '**********************'
	echo '.'

	export DEBIAN_FRONTEND=noninteractive

	echo '.'
	echo '**********************'
	echo '* Suppression du processus en cour : apt-get'
	echo '**********************'
	echo '.'

	sudo killall apt apt-get

	echo '.'   
	echo '**********************'
	echo '* Mise a jour global'
	echo '**********************'
	echo '.'

	sudo apt-get update -y

	echo '.'   
	echo '**********************'
	echo '* Installation de : '
	echo '* - git'
	echo '* - software-properties-common'
	echo '**********************'
	echo '.'

	sudo apt-get install git software-properties-common -y

	echo '.'
	echo '**********************'
	echo '* Installation de : '
	echo '* - ansible'
	echo '**********************'
	echo '.'

	sudo apt-add-repository --yes --update ppa:ansible/ansible
	sudo apt-get install ansible -y
	sudo add-apt-repository --yes --remove ppa:PPA_Name/ppa

	echo '.'
	echo '**********************'
	echo '* Installation de : '
	echo '* - openssh-server'
	echo '**********************'
	echo '.'

	sudo apt-get install openssh-server -y

	echo '.'   
	echo '**********************'
	echo '* Controle version'
	echo '**********************'
	echo '.'

	ansible --version

	echo '.'   
	echo '**********************'
	echo '* Mise en place des fichiers Pi-Kube'
	echo '**********************'
	echo '.'
	
	if [ ! -d "/opt/pi-kube" ]; then
		echo 'n existe pas'
		cd /opt/
		
		sudo git clone https://github.com/tips-of-mine/pi-kube.git
	else
		echo 'existe'
		sudo mkdir -p /opt/pi-kube-bakcup-file
		
		sudo cp /opt/pi-kube/hosts /opt/pi-kube-bakcup-file/hosts
		
		sudo rm -Rf /opt/pi-kube
		
		sudo git clone https://github.com/tips-of-mine/pi-kube.git
		
		sudo cp /opt/pi-kube-bakcup-file/hosts /opt/pi-kube/hosts
	fi
 
else
	echo "Unsupported OS"
	exit
fi