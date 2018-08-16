#!/bin/bash
# open port 9000 to access hdfs
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

HADOOP_DIR="${DIR}/../tools/bin/hadoop/bin"
HADOOP_CMD="${HADOOP_DIR}/hadoop"
HOST=localhost
PORT=8020
HDFS_URL=hdfs://${HOST}:${PORT}/csv/
#HDFS_PATH=${HOME}/Entwicklung/docker-hadoop-spark-workbench/data/datanode/current/csv
#HDFS_PATH=${HOME}/Entwicklung/docker-hadoop-spark-workbench/data/namenode/csv

export HADOOP_USER_NAME="root"

# ------------- variables --------------------


${HADOOP_CMD} fs -copyToLocal hdfs://127.0.0.1:50075/webhdfs/v1/user/automotive/join.txt ./
