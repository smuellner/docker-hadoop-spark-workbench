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

DATA_PATH="${DIR}/data"
HADOOP_ENV="${DIR}/../hadoop.env"
DOCKER_EXECUTE_NAMENODE_CMD="docker run -it --rm --env-file=${HADOOP_ENV} --net docker-hadoop-spark-workbench_spark bde2020/hadoop-namenode:1.1.0-hadoop2.8-java8"
DOCKER_EXECUTE_DATANODE_CMD="docker run -it --rm --env-file=${HADOOP_ENV} --volume ${DATA_PATH}:/data --net docker-hadoop-spark-workbench_spark bde2020/hadoop-datanode:1.1.0-hadoop2.8-java8"

export HADOOP_USER_NAME="root"

# ------------- variables --------------------

${DOCKER_EXECUTE_DATANODE_CMD} hadoop fs -rm -R /user/GA/SRC1
${DOCKER_EXECUTE_DATANODE_CMD} hadoop fs -rm -R /user/GA/SRC2

${DOCKER_EXECUTE_NAMENODE_CMD} hadoop fs -mkdir -p /user/GA/SRC1
${DOCKER_EXECUTE_NAMENODE_CMD} hadoop fs -mkdir -p /user/GA/SRC2
 
${DOCKER_EXECUTE_DATANODE_CMD} hadoop fs -put /data/CSV1/* /user/GA/SRC1
${DOCKER_EXECUTE_DATANODE_CMD} hadoop fs -put /data/CSV2/* /user/GA/SRC2

${DOCKER_EXECUTE_NAMENODE_CMD} hadoop fs -ls /user/GA/SRC1
${DOCKER_EXECUTE_NAMENODE_CMD} hadoop fs -ls /user/GA/SRC2
