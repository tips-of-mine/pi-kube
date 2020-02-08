#!/bin/sh
set -e

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

echo '.'
echo '\n'
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

if command_exists lsb_release; then
	# Check if the `-u` option is supported
	set +e
	lsb_release -a -u > /dev/null 2>&1
	lsb_release_exit_code=$?
	set -e

	# Check if the command has exited successfully, it means we're in a forked distro
	if [ "$lsb_release_exit_code" = "0" ]; then
		# Print info about current distro
		cat <<-EOF
			You're using '$lsb_dist' version '$dist_version'.
			EOF

			# Get the upstream release info
			lsb_dist=$(lsb_release -a -u 2>&1 | tr '[:upper:]' '[:lower:]' | grep -E 'id' | cut -d ':' -f 2 | tr -d '[[:space:]]')
			dist_version=$(lsb_release -a -u 2>&1 | tr '[:upper:]' '[:lower:]' | grep -E 'codename' | cut -d ':' -f 2 | tr -d '[[:space:]]')

			# Print info about upstream distro
			cat <<-EOF
			Upstream release is '$lsb_dist' version '$dist_version'.
			EOF
	else
		if [ -r /etc/debian_version ] && [ "$lsb_dist" != "ubuntu" ] && [ "$lsb_dist" != "raspbian" ]; then
			# We're Debian and don't even know it!
			lsb_dist=debian
			dist_version="$(cat /etc/debian_version | sed 's/\/.*//' | sed 's/\..*//')"
			case "$dist_version" in
				10)
					dist_version="buster"
				        echo 'buster'
				;;
				9)
					dist_version="stretch"
					echo 'stretch'
				;;
				8|'Kali Linux 2')
					dist_version="jessie"
					echo 'jessie'
				;;
				7)
					dist_version="wheezy"
					echo 'wheezy'
				;;
			esac
		fi
	fi
else
        echo 'ici'
fi
