#!/bin/bash
#
# ./tools/install.sh
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
# Hadoop
HADOOP_NAME="hadoop"
HADOOP_VERSION="2.8.4"
HADOOP_EXTENSION="tar.gz"
HADOOP_FOLDER_NAME="${HADOOP_NAME}-${HADOOP_VERSION}"
HADOOP_ARCHIVE="${HADOOP_FOLDER_NAME}.${HADOOP_EXTENSION}"
HADOOP_URL="http://www-eu.apache.org/dist/hadoop/common/${HADOOP_NAME}-${HADOOP_VERSION}/${HADOOP_ARCHIVE}"
# Spark
SPARK_NAME="spark"
#SPARK_VERSION="2.1.0"
SPARK_VERSION="2.3.1"
SPARK_EXTENSION="tgz"
SPARK_FOLDER_NAME="${SPARK_NAME}-${SPARK_VERSION}-bin-hadoop2.7"
SPARK_ARCHIVE="${SPARK_FOLDER_NAME}.${SPARK_EXTENSION}"
SPARK_URL="https://archive.apache.org/dist/spark/${SPARK_NAME}-${SPARK_VERSION}/${SPARK_ARCHIVE}"

# ------------- variables --------------------

${MKDIR} ${DIR}/bin/

rm -rf ${DIR}/bin/${HADOOP_NAME}
${ECHO} "Downloading Hadoop ${HADOOP_URL}"
${CURL} ${HADOOP_URL} > ${DIR}/${HADOOP_ARCHIVE}
${TAR} -xzf ${DIR}/${HADOOP_ARCHIVE} -C ${DIR}
${ECHO} "Moving Hadoop ${HADOOP_FOLDER_NAME} to ${DIR}/bin/${HADOOP_NAME}"
mv ${DIR}/${HADOOP_FOLDER_NAME} ${DIR}/bin/${HADOOP_NAME}
rm  ${DIR}/${HADOOP_ARCHIVE}
rm -rf ${DIR}/${HADOOP_FOLDER_NAME}

rm -rf ${DIR}/bin/${SPARK_NAME}
${ECHO} "Downloading Spark ${SPARK_URL}"
${CURL} ${SPARK_URL} > ${DIR}/${SPARK_ARCHIVE}
${TAR} -xzf ${DIR}/${SPARK_ARCHIVE} -C ${DIR}
${ECHO} "Moving Spark ${SPARK_FOLDER_NAME} to ${DIR}/bin/${SPARK_NAME}"
mv ${DIR}/${SPARK_FOLDER_NAME} ${DIR}/bin/${SPARK_NAME}
rm  ${DIR}/${SPARK_ARCHIVE}
rm -rf ${DIR}/${SPARK_FOLDER_NAME}
