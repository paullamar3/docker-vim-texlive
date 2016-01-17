#!/bin/bash

## An "entrypoint" script for the docker-vim-texlive container

set -e

USAGE="$(basename "$0") [-h] [-u USER] [-U UID] [-G GID] 
                     [-g GIT_NAME] [-e GIT_EMAIL]
		     [ARGS]

This script starts the Vim process inside the 
docker-vim-texlive container. It supports some optional arguments
to customize how the process is started.

     -h            Display this help message.

     -u USER       Name of new user container should use.

     -U UID        ID of new user container should use.

     -G GID        ID of the group created for the new user.

     -g GIT_NAME   The Git global user.name for the new user.

     -e GIT_EMAIL  The Git global user.email for the new user.

     ARGS          Additional arguments for this script.

"

# First set up the default values for the options.
new_user=""
new_uid=""
new_gid=""
git_nm=""
git_email=""

# Parse any options
while getopts ":hu:U:G:g:e:" opt; do
	case $opt in
		h) 
			echo "$USAGE"
			exit
			;;
		u)
			new_user="$OPTARG"
			;;
		U)
			new_uid="-u $OPTARG"
			;;
		G)
			new_gid="-g $OPTARG"
			;;
		g)
			git_nm="$OPTARG"
			;;
		e)
			git_email="$OPTARG"
			;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			exit 1
			;;
		:)
			echo "Option -$OPTARG requires an argument." >&2
			exit 1
			;;
	esac
done

if [ -n "$new_user" -a -z "$( getent passwd $new_user )" ]; then
	p_adduser "$new_uid" "$new_gid" "$new_user" "$new_user"
	runuser -u "$new_user" -- vim -c "PlugInstall|q|q"
	runuser -u "$new_user" tlmgr init-usertree
elif [ -z "$new_user" -a ! -f /root/initialized ]; then
	vim -c "PlugInstall|q|q"
	tlmgr init-usertree
	touch /root/initialized
fi

if [ -n "$git_nm" -a -n "$git_email" -a -z "$( git config user.name )" ]; then
	if [ -n "$new_user" ]; then
		runuser -u "$new_user"  git config --global user.name "$git_nm"
		runuser -u "$new_user"  git config --global user.email "$git_email"
	else
		git config --global user.name "$git_nm"
		git config --global user.email "$git_email"
	fi
fi

if [ -n "$new_user" ]; then 
	gosu "$new_user" vim --servername VIM
else
	exec vim --servername VIM
fi

