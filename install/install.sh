#!/bin/bash
#
# For now we assume this is debian or Ubuntu
# ./install/install.sh
#
### END INIT INFO
########################################################################
# ------------- important settings for this script ---------------------
# which is the only command we need to detect the other commands ;)
WHICH="/usr/bin/which";
# if which doesnt work for you - you have to set the pathes manually
# like this: ECHO=/bin/echo;

if [ -z "$WHICH" ]; then
{
        $ECHO "Error: Missing which - please edit the 11. line of this script!";
        exit 255;
}
fi;

# ------------- system commands used by this script --------------------
ID=`$WHICH "id"`;
ECHO=`$WHICH "echo"`;
export ID ECHO;

CAT=`$WHICH "cat"`;
BASH=`$WHICH "bash"`;
FIND=`$WHICH "find"`;
GREP=`$WHICH "grep"`;
CUT=`$WHICH "cut"`;
SED=`$WHICH "sed"`;
MKDIR=`$WHICH "mkdir"`;
CHMOD=`$WHICH "chmod"`;
CHOWN=`$WHICH "chown"`;
CURL=`$WHICH "curl"`;
TAR=`$WHICH "tar"`;
export CAT BASH FIND GREP CUT SED MKDIR CHMOD CHOWN CURL;
# ------------- system commands used by this script --------------------

# ------------- variables --------------------
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
fi
if [[ $platform == 'linux' ]]; then
        DIR=$(dirname "$(readlink -f "$0")")
else
        DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
fi
WHOAMI=`whoami`
# ------------- variables --------------------

## Update packages and Upgrade system
sudo apt-get update -y

## Git ##
echo '###Installing Git..'
sudo apt-get install git -y

## Docker ##
echo '###Installing Docker..'
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh

echo '###Configure Docker..'
sudo usermod -aG docker ${WHOAMI}

echo '###Installing Docker Compose..'
sudo apt-get install docker-compose -y

## Cloning Repository ##
echo '###Cloning the Repository..'
mkdir -p ${HOME}/projects
cd ${HOME}/projects
git clone https://github.com/smuellner/docker-hadoop-spark-workbench.git
echo WHOAMI: ${WHOAMI}
sudo chown -R ${WHOAMI} ${HOME}/projects/docker-hadoop-spark-workbench
cd ${HOME}/projects/docker-hadoop-spark-workbench
git pull

## Install Tools ##
echo '###Installing Tools..'
${HOME}/projects/docker-hadoop-spark-workbench/tools/install.sh
