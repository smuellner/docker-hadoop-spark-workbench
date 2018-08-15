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

${HADOOP_CMD} fs -mkdir ${HDFS_URL}


${HADOOP_CMD} fs -put ./data/accelerations.csv ${HDFS_URL}
# ${HADOOP_CMD} dfs -put ./data/beaglebones.csv ${HDFS_PATH}
#${HADOOP_CMD} dfs -put ./data/gyroscopes.csv ${HDFS_URL}
#${HADOOP_CMD} dfs -put ./data/obdData.csv ${HDFS_URL}
#${HADOOP_CMD} dfs -put ./data/positions.csv ${HDFS_URL}
#${HADOOP_CMD} dfs -put ./data/trips.csv ${HDFS_URL}
${HADOOP_CMD} fs -ls ${HDFS_PATH}
