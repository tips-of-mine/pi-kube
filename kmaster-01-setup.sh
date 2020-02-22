#!/bin/sh
set -e

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

echo '.'
sleep 2
echo '\n'
echo '.'
echo '\e[93m'
echo '  /$$$$$$$$ /$$$$$$ /$$$$$$$   /$$$$$$           /$$$$$$  /$$$$$$$$      /$$      /$$ /$$$$$$ /$$   /$$ /$$$$$$$$'
echo ' |__  $$__/|_  $$_/| $$__  $$ /$$__  $$         /$$__  $$| $$_____/     | $$$    /$$$|_  $$_/| $$$ | $$| $$_____/'
echo '    | $$     | $$  | $$  \ $$| $$  \__/        | $$  \ $$| $$           | $$$$  /$$$$  | $$  | $$$$| $$| $$      '
echo '    | $$     | $$  | $$$$$$$/|  $$$$$$  /$$$$$$| $$  | $$| $$$$$ /$$$$$$| $$ $$/$$ $$  | $$  | $$ $$ $$| $$$$$   '
echo '    | $$     | $$  | $$$$$$$/|  $$$$$$  /$$$$$$| $$  | $$| $$$$$ /$$$$$$| $$ $$/$$ $$  | $$  | $$ $$ $$| $$$$$   '
echo '    | $$     | $$  | $$____/  \____  $$|______/| $$  | $$| $$__/|______/| $$  $$$| $$  | $$  | $$  $$$$| $$__/   '
echo '    | $$     | $$  | $$       /$$  \ $$        | $$  | $$| $$           | $$\  $ | $$  | $$  | $$\  $$$| $$      '
echo '    | $$    /$$$$$$| $$      |  $$$$$$/        |  $$$$$$/| $$           | $$ \/  | $$ /$$$$$$| $$ \  $$| $$$$$$$$'
echo '    |__/   |______/|__/       \______/          \______/ |__/           |__/     |__/|______/|__/  \__/|________/'
echo '\e[97m'
echo '.'
echo '\e[92m'
echo '  /$$$$$$$  /$$         /$$   /$$ /$$   /$$ /$$$$$$$  /$$$$$$$$'
echo ' | $$__  $$|__/        | $$  /$$/| $$  | $$| $$__  $$| $$_____/'
echo ' | $$  \ $$ /$$        | $$ /$$/ | $$  | $$| $$  \ $$| $$'
echo ' | $$$$$$$/| $$ /$$$$$$| $$$$$/  | $$  | $$| $$$$$$$ | $$$$$'
echo ' | $$____/ | $$|______/| $$  $$  | $$  | $$| $$__  $$| $$__/'
echo ' | $$      | $$        | $$\  $$ | $$  | $$| $$  \ $$| $$'
echo ' | $$      | $$        | $$ \  $$|  $$$$$$/| $$$$$$$/| $$$$$$$$'
echo ' |__/      |__/        |__/  \__/ \______/ |_______/ |________/'
echo '\e[97m'
echo '.'

architecture=$(uname -m)

case $architecture in
	# Officiellement supporté
	amd64|aarch64|arm64|x86_64)
		# Futur action possible a mettre ICI
		echo ' - Architecture \e[35mamd64/aarch64/arm64/x86_64 \e[97m- \e[32mOK'
		echo '\e[97m'
		;;
	# Non officiellement supporté avec divers repositories
	armv6l|armv7l)
		# Futur action possible a mettre ICI
		echo ' - Architecture \e[35marmv6l/armv7l \e[97m- \e[32mOK'
		echo '\e[97m'
		;;
	# Non officiellement supporté sans divers repositories
	ppc64le|s390x)
		cat 1>&2 <<-EOF
			Erreur: This install script does not support $architecture, because no
			$architecture package exists in Docker's repositories.

			Other install options include checking your distribution's package repository
			for a version of Docker, or building Docker from source.
		EOF
		exit 1
		;;
	# Non supporté
	*)
		cat >&2 <<-EOF
			Erreur: $architecture n'est pas recommandé pour votre plateforme.

			Sortie du script
		EOF
		exit 1
		;;
esac

user="$(id -un 2>/dev/null || true)"

# variable d execution
sh_c='sh -c'

# controle l'utilisateur d execution
if [ "$user" != 'root' ]; then
	# si different de root
	if command_exists sudo; then
		echo ' - Utilisation de la commande \e[35mSUDO \e[97m- \e[32mOK'
		echo '\e[97m'
		sh_c='sudo -E sh -c'
	elif command_exists su; then
		echo ' - Utilisation de la commande \e[35mSU -C \e[97m- \e[32mOK'
		echo '\e[97m'
		sh_c='su -c'
	else
		cat >&2 <<-'EOF'
			Erreur : l'installeur doit être capable d'exécuter des commandes en tant que root.
			Nous ne trouvons ni "sudo" ni "su" disponibles pour cela.

			Sortie du script			
			EOF
		exit 1
	fi
else
	# si root de rien faire
	echo '.'
fi

curl=''
if command_exists curl; then
	echo ' - Utilisation de la commande \e[35mCURL \e[97m- \e[32mOK'
	echo '\e[97m'
	curl='curl -sSL'
elif command_exists wget; then
	echo ' - Utilisation de la commande \e[35mWGET -qO- \e[97m- \e[32mOK'
	echo '\e[97m'
	curl='wget -qO-'
elif command_exists busybox && busybox --list-modules | grep -q wget; then
	echo ' - Utilisation de la commande \e[35mBUSYBOX WGET -qO- \e[97m- \e[32mOK'
	echo '\e[97m'
	curl='busybox wget -qO-'
else
	echo '. \e[31m ERREUR NON PREVU'
fi

# effectuer une détection de plate-forme très rudimentaire
lsb_dist=''
dist_version=''

if command_exists lsb_release; then
	lsb_dist="$(lsb_release -si)"
else
	echo ' - Utilisation de la commande \e[35mlsb_release \e[97m- \e[31mKO'
	echo '\e[97m'
fi

if [ -z "$lsb_dist" ] && [ -r /etc/lsb-release ]; then
	lsb_dist="$(. /etc/lsb-release && echo "$DISTRIB_ID")"
else
	echo ' - Utilisation du fichier \e[35m/etc/lsb-release \e[97m- \e[31mKO'
	echo '\e[97m'
fi

if [ -z "$lsb_dist" ] && [ -r /etc/debian_version ]; then
	lsb_dist='debian'
else
	echo ' - Utilisation du fichier \e[35m/etc/debian_version \e[97m- \e[31mKO'
	echo '\e[97m'
fi

if [ -z "$lsb_dist" ] && [ -r /etc/os-release ]; then
	lsb_dist="$(. /etc/os-release && echo "$ID")"
else
	echo ' - Utilisation du fichier \e[35m/etc/os-release \e[97m- \e[31mKO'
	echo '\e[97m'
fi

lsb_dist="$(echo "$lsb_dist" | tr '[:upper:]' '[:lower:]')"

case "$lsb_dist" in
	ubuntu)
		if command_exists lsb_release; then
			dist_version="$(lsb_release --codename | cut -f2)"
		fi
		if [ -z "$dist_version" ] && [ -r /etc/lsb-release ]; then
			dist_version="$(. /etc/lsb-release && echo "$DISTRIB_CODENAME")"
		fi
		;;
	debian|raspbian)
		echo '\e[97m.'
		echo '\e[36m'
		echo '        /$$           /$$       /$$'
		echo '       | $$          | $$      |__/'
		echo '   /$$$$$$$  /$$$$$$ | $$$$$$$  /$$  /$$$$$$  /$$$$$$$'
		echo '  /$$__  $$ /$$__  $$| $$__  $$| $$ |____  $$| $$__  $$'
		echo ' | $$  | $$| $$$$$$$$| $$  \ $$| $$  /$$$$$$$| $$  \ $$'
		echo ' | $$  | $$| $$_____/| $$  | $$| $$ /$$__  $$| $$  | $$'
		echo ' |  $$$$$$$|  $$$$$$$| $$$$$$$/| $$|  $$$$$$$| $$  | $$'
	 	echo ' \_______/ \_______/|_______/ |__/ \_______/|__/  |__/'
		echo '\e[97m.'

		dist_version="$(cat /etc/debian_version | sed 's/\/.*//' | sed 's/\..*//')"
		case "$dist_version" in
			10)
				dist_version="buster"
				echo '\e[36m'
				echo '  /$$                             /$$'
				echo ' | $$                            | $$'
				echo ' | $$$$$$$  /$$   /$$  /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$'
				echo ' | $$__  $$| $$  | $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$'
				echo ' | $$  \ $$| $$  | $$|  $$$$$$   | $$    | $$$$$$$$| $$  \__/'
				echo ' | $$  | $$| $$  | $$ \____  $$  | $$ /$$| $$_____/| $$'
				echo ' | $$$$$$$/|  $$$$$$/ /$$$$$$$/  |  $$$$/|  $$$$$$$| $$'
				echo ' |_______/  \______/ |_______/    \___/   \_______/|__/'
				echo '\e[97m.'

				echo '.'
				echo '**********************'
				echo '* Parametrage'
				echo '**********************'
				echo '.'

#				deprecation_notice "$lsb_dist"
				export DEBIAN_FRONTEND=noninteractive

				echo '.'
				echo '**********************'
				echo '* Suppression du processus en cour : apt-get'
				echo '**********************'
				echo '.'

#				( set -x; $sh_c 'sleep 3; killall apt apt-get' )

				echo '.'   
				echo '**********************'
				echo '* Mise a jour global'
				echo '**********************'
				echo '.'

				did_apt_get_update=
				apt_get_update() {
					if [ -z "$did_apt_get_update" ]; then
						( set -x; $sh_c 'sleep 3; apt-get update' )
						did_apt_get_update=1
					fi
				}
				
				( set -x; $sh_c 'sleep 3; apt-get update' )
				( set -x; $sh_c 'sleep 3; apt-get dist-upgrade' )
				
				echo '.'   
				echo '**********************'
				echo '* Installation de : '
				echo '* - git'
				echo '* - software-properties-common'
				echo '**********************'
				echo '.'

				( set -x; $sh_c 'sleep 3; apt-get install -y -q git software-properties-common' )

				echo '.'
				echo '**********************'
				echo '* Installation de : '
				echo '* - ansible'
				echo '**********************'
				echo '.'

				( set -x; $sh_c 'sleep 3; apt-get install ansible -y' )

				echo '.'   
				echo '**********************'
				echo '* Controle version'
				echo '**********************'
				echo '.'

				( set -x; $sh_c 'sleep 3; ansible --version' )


				echo '.'   
				echo '**********************'
				echo '* Mise en place des fichiers Pi-Kube'
				echo '**********************'
				echo '.'

				if [ ! -d "/opt/pi-kube" ]; then
					echo 'n existe pas'
					( set -x; $sh_c 'sleep 3; cd /opt/' )
		
					( set -x; $sh_c 'sleep 3; git clone https://github.com/tips-of-mine/pi-kube.git /opt/pi-kube' )

					( set -x; $sh_c 'sleep 3; cp /opt/pi-kube/kmaster-01-setup.sh /opt/kmaster-01-setup.sh' )
				else
					echo 'existe'
					( set -x; $sh_c 'sleep 3; mkdir -p /opt/pi-kube-bakcup-file' )
		
					( set -x; $sh_c 'sleep 3; cp /opt/pi-kube/hosts /opt/pi-kube-bakcup-file/hosts' )
		
					( set -x; $sh_c 'sleep 3; rm -Rf /opt/pi-kube' )
		
					( set -x; $sh_c 'sleep 3; git clone https://github.com/tips-of-mine/pi-kube.git /opt/pi-kube' )
	
					( set -x; $sh_c 'sleep 3; cp /opt/pi-kube-bakcup-file/hosts /opt/pi-kube/hosts' )

					( set -x; $sh_c 'sleep 3; cp /opt/pi-kube/kmaster-01-setup.sh /opt/kmaster-01-setup.sh' )
				fi
				;;
			9)
				dist_version="stretch"
				echo '\e[36m'
				echo '              /$$                           /$$               /$$'
				echo '             | $$                          | $$              | $$'
				echo '   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$  /$$$$$$    /$$$$$$$| $$$$$$$'
				echo '  /$$_____/|_  $$_/   /$$__  $$ /$$__  $$|_  $$_/   /$$_____/| $$__  $$'
				echo ' |  $$$$$$   | $$    | $$  \__/| $$$$$$$$  | $$    | $$      | $$  \ $$'
				echo '  \____  $$  | $$ /$$| $$      | $$_____/  | $$ /$$| $$      | $$  | $$'
				echo '  /$$$$$$$/  |  $$$$/| $$      |  $$$$$$$  |  $$$$/|  $$$$$$$| $$  | $$'
				echo ' |_______/    \___/  |__/       \_______/   \___/   \_______/|__/  |__/'
				echo '\e[97m.'
				;;
			8)
				dist_version="jessie"
				echo '\e[36m'

				echo '\e[97m.'
				;;
			7)
				dist_version="wheezy"
				echo '\e[36m'

				echo '\e[97m.'
				;;
		esac
		;;
	*)
		if command_exists lsb_release; then
			dist_version="$(lsb_release --codename | cut -f2)"
		fi
		if [ -z "$dist_version" ] && [ -r /etc/os-release ]; then
			dist_version="$(. /etc/os-release && echo "$VERSION_ID")"
		fi
		;;
esac