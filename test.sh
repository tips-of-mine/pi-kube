#!/bin/sh
set -e

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

echo '.'
echo '\n'
echo '.'
echo '  /$$$$$$$$ /$$$$$$ /$$$$$$$   /$$$$$$           /$$$$$$  /$$$$$$$$      /$$      /$$ /$$$$$$ /$$   /$$ /$$$$$$$$'
echo ' |__  $$__/|_  $$_/| $$__  $$ /$$__  $$         /$$__  $$| $$_____/     | $$$    /$$$|_  $$_/| $$$ | $$| $$_____/'
echo '    | $$     | $$  | $$  \ $$| $$  \__/        | $$  \ $$| $$           | $$$$  /$$$$  | $$  | $$$$| $$| $$      '
echo '    | $$     | $$  | $$$$$$$/|  $$$$$$  /$$$$$$| $$  | $$| $$$$$ /$$$$$$| $$ $$/$$ $$  | $$  | $$ $$ $$| $$$$$   '
echo '    | $$     | $$  | $$$$$$$/|  $$$$$$  /$$$$$$| $$  | $$| $$$$$ /$$$$$$| $$ $$/$$ $$  | $$  | $$ $$ $$| $$$$$   '
echo '    | $$     | $$  | $$____/  \____  $$|______/| $$  | $$| $$__/|______/| $$  $$$| $$  | $$  | $$  $$$$| $$__/   '
echo '    | $$     | $$  | $$       /$$  \ $$        | $$  | $$| $$           | $$\  $ | $$  | $$  | $$\  $$$| $$      '
echo '    | $$    /$$$$$$| $$      |  $$$$$$/        |  $$$$$$/| $$           | $$ \/  | $$ /$$$$$$| $$ \  $$| $$$$$$$$'
echo '    |__/   |______/|__/       \______/          \______/ |__/           |__/     |__/|______/|__/  \__/|________/'
echo '.'
echo '  /$$$$$$$  /$$         /$$   /$$ /$$   /$$ /$$$$$$$  /$$$$$$$$'
echo ' | $$__  $$|__/        | $$  /$$/| $$  | $$| $$__  $$| $$_____/'
echo ' | $$  \ $$ /$$        | $$ /$$/ | $$  | $$| $$  \ $$| $$'
echo ' | $$$$$$$/| $$ /$$$$$$| $$$$$/  | $$  | $$| $$$$$$$ | $$$$$'
echo ' | $$____/ | $$|______/| $$  $$  | $$  | $$| $$__  $$| $$__/'
echo ' | $$      | $$        | $$\  $$ | $$  | $$| $$  \ $$| $$'
echo ' | $$      | $$        | $$ \  $$|  $$$$$$/| $$$$$$$/| $$$$$$$$'
echo ' |__/      |__/        |__/  \__/ \______/ |_______/ |________/'
echo '.'

if command_exists lsb_release
then

	set +e
	lsb_release -a -u > /dev/null 2>&1
	lsb_release_exit_code=$?
	set -e

	if [ "$lsb_release_exit_code" = "0" ]
	then

		cat <<-EOF
			Vous utilisez '$lsb_dist' version '$dist_version'.
			EOF

			lsb_dist=$(lsb_release -a -u 2>&1 | tr '[:upper:]' '[:lower:]' | grep -E 'id' | cut -d ':' -f 2 | tr -d '[[:space:]]')
			dist_version=$(lsb_release -a -u 2>&1 | tr '[:upper:]' '[:lower:]' | grep -E 'codename' | cut -d ':' -f 2 | tr -d '[[:space:]]')

			cat <<-EOF
			Upstream release is '$lsb_dist' version '$dist_version'.
			EOF
	else
		if [ -r /etc/debian_version ] && [ "$lsb_dist" != "ubuntu" ] && [ "$lsb_dist" != "raspbian" ]
		then

			lsb_dist=debian
			dist_version="$(cat /etc/debian_version | sed 's/\/.*//' | sed 's/\..*//')"

			case "$dist_version" in
				10)
					dist_version="buster"
				;;
				9)
					dist_version="stretch"
				;;
				8|'Kali Linux 2')
					dist_version="jessie"
				;;
				7)
					dist_version="wheezy"
				;;
			esac
		fi
	fi
else
        echo ' - Erreur'
fi

if [ $dist_version = "buster" ]
then

	echo '.'
	echo '        /$$           /$$       /$$'
	echo '       | $$          | $$      |__/'
	echo '   /$$$$$$$  /$$$$$$ | $$$$$$$  /$$  /$$$$$$  /$$$$$$$'
	echo '  /$$__  $$ /$$__  $$| $$__  $$| $$ |____  $$| $$__  $$'
	echo ' | $$  | $$| $$$$$$$$| $$  \ $$| $$  /$$$$$$$| $$  \ $$'
	echo ' | $$  | $$| $$_____/| $$  | $$| $$ /$$__  $$| $$  | $$'
	echo ' |  $$$$$$$|  $$$$$$$| $$$$$$$/| $$|  $$$$$$$| $$  | $$'
 	echo ' \_______/ \_______/|_______/ |__/ \_______/|__/  |__/'
	echo '.'
	echo '  /$$                             /$$'
	echo ' | $$                            | $$'
	echo ' | $$$$$$$  /$$   /$$  /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$'
	echo ' | $$__  $$| $$  | $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$'
	echo ' | $$  \ $$| $$  | $$|  $$$$$$   | $$    | $$$$$$$$| $$  \__/'
	echo ' | $$  | $$| $$  | $$ \____  $$  | $$ /$$| $$_____/| $$'
	echo ' | $$$$$$$/|  $$$$$$/ /$$$$$$$/  |  $$$$/|  $$$$$$$| $$'
	echo ' |_______/  \______/ |_______/    \___/   \_______/|__/'
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

	( set -x; $sh_c 'sudo killall apt apt-get')

	echo '.'   
	echo '**********************'
	echo '* Mise a jour global'
	echo '**********************'
	echo '.'

	( set -x; $sh_c 'sleep 3; sudo apt-get update -y')

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
	
	if [ ! -d "/opt/pi-kube" ]
	then
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
elif  [ $dist_version = "stretch" ]
then
	echo '.'
	echo '        /$$           /$$       /$$'
	echo '       | $$          | $$      |__/'
	echo '   /$$$$$$$  /$$$$$$ | $$$$$$$  /$$  /$$$$$$  /$$$$$$$'
	echo '  /$$__  $$ /$$__  $$| $$__  $$| $$ |____  $$| $$__  $$'
	echo ' | $$  | $$| $$$$$$$$| $$  \ $$| $$  /$$$$$$$| $$  \ $$'
	echo ' | $$  | $$| $$_____/| $$  | $$| $$ /$$__  $$| $$  | $$'
	echo ' |  $$$$$$$|  $$$$$$$| $$$$$$$/| $$|  $$$$$$$| $$  | $$'
 	echo ' \_______/ \_______/|_______/ |__/ \_______/|__/  |__/'
	echo '.'
	echo '              /$$                           /$$               /$$'
	echo '             | $$                          | $$              | $$'
	echo '   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$  /$$$$$$    /$$$$$$$| $$$$$$$'
	echo '  /$$_____/|_  $$_/   /$$__  $$ /$$__  $$|_  $$_/   /$$_____/| $$__  $$'
	echo ' |  $$$$$$   | $$    | $$  \__/| $$$$$$$$  | $$    | $$      | $$  \ $$'
	echo '  \____  $$  | $$ /$$| $$      | $$_____/  | $$ /$$| $$      | $$  | $$'
	echo '  /$$$$$$$/  |  $$$$/| $$      |  $$$$$$$  |  $$$$/|  $$$$$$$| $$  | $$'
	echo ' |_______/    \___/  |__/       \_______/   \___/   \_______/|__/  |__/'
	echo '.'
	
	exit 0
elif  [ $dist_version = "jessie" ]
then
	echo "jessie Unsupported OS"
	exit 0
elif  [ $dist_version = "wheezy" ]
then
	echo "wheezy Unsupported OS"
	exit 0
else
	echo "Other Unsupported OS"
	exit 1
fi
