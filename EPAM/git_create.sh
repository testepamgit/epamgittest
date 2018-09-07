#!/bin/bash

# Create and push to a new github repo from the command line.  
# Grabs sensible defaults from the containing folder and `.gitconfig`.  
# Script based on https://gist.github.com/xixixao/7979913
# Author: Georgi Georgiev 
# hipo@pc-freak.net

#REPONAME='epamtest';
REPONAME="$1";
USER='testepamgit';
GITHUBUSER="$USER";
PASSWD='TestqWerty43#';
DESCRIPTION='this is a test git commit';
# Gather constant vars
CURRENTDIR=${PWD##*/}
REPO_DIR='EPAM';
HOME="/home/devops";
CURL=$(which curl);
git=$(which git);
API_URL='https://api.github.com/user/repos';
GITHUBUSER=$(git config github.user)
RANDOM=$((RANDOM%100))
# install git and curl if they're missing on the system (for that to work must run as root user)

if [ ! -z "$1" ]; then
	echo 'OK'
else
	echo 'Missing REPONAME argument or other error ... exiting';
	exit 1;
fi

rm -rf $HOME/.git

if [ ! -d $HOME/.git ]; then
	cd ~
	$git init;
echo 'Git Local Repo Initialized';
##for i in $(ls -1 ~/EPAM); do 
	echo "Adding content from $HOME to $REPO_DIR ..";
	 ##$git config --global user.email "hipodilski@gmail.com"
	   ##$git config --global user.name "$USER"

	$git add $HOME/$REPO_DIR/.; 
##	echo "Adding $i to repository";

##done

$git commit $HOME/$REPO_DIR/. -m "EPAM $RANDOM"

echo "Commiting";

else 
	echo ".git exists"
fi


echo "Here we go..."
#echo "lynx -dump https://github.com/${GITHUBUSER}/$REPONAME.git |grep -i 404 |wc -l";
#if [ $(lynx -dump https://github.com/${GITHUBUSER}/$REPONAME.git|grep -i 404|wc -l) -eq 1 ]; then 
#	echo 'Missing repository good about to create';
#
#

#else
#	echo 'Existing repository .. exiting';
#fi
#exit 0
# Curl some json to the github API oh damn we so fancy
$CURL -u ${USER:-${GITHUBUSER}}:"$PASSWD" $API_URL -d "{\"name\": \"${REPONAME:-${CURRENTDIR}}\", \"description\": \"${DESCRIPTION}\", \"private\": false, \"has_issues\": true, \"has_downloads\": true, \"has_wiki\": false}"
# Set the freshly created repo to the origin and push
# You'll need to have added your public key to your github account
##$git remote add origin git@github.com:${USER:-${GITHUBUSER}}/${REPONAME:-${CURRENTDIR}}.git
  git config --global user.email "hipodilski@gmail.com"
    git config --global user.name "$USER"
##git commit -m "Commit $RANDOM"
##git push origin master
$git remote add origin git@github.com:${USER:-${GITHUBUSER}}/${REPONAME:-${CURRENTDIR}}.git

$git push --set-upstream origin master



