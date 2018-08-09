#!/bin/sh
# open port 9000 to access hdfs
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
HADOOP_ENV="${DIR}/../hadoop.env"
DOCKER_EXECUTE_NAMENODE_CMD="docker run -it --rm --env-file=${HADOOP_ENV} --net docker-hadoop-spark-workbench_spark bde2020/hadoop-namenode:1.1.0-hadoop2.8-java8"
DOCKER_EXECUTE_DATANODE_CMD="docker run -it --rm --env-file=${HADOOP_ENV} --volume ${PWD}:/data --net docker-hadoop-spark-workbench_spark bde2020/hadoop-datanode:1.1.0-hadoop2.8-java8"

export HADOOP_USER_NAME="root"
${DOCKER_EXECUTE_NAMENODE_CMD} hadoop fs -mkdir -p /user/automotive

cd data
${DOCKER_EXECUTE_DATANODE_CMD} hadoop fs -put /data/accelerations.csv /user/automotive
${DOCKER_EXECUTE_DATANODE_CMD} hadoop fs -put /data/beaglebones.csv /user/automotive
${DOCKER_EXECUTE_DATANODE_CMD} hadoop fs -put /data/gyroscopes.csv /user/automotive
${DOCKER_EXECUTE_DATANODE_CMD} hadoop fs -put /data/obdData.csv /user/automotive
${DOCKER_EXECUTE_DATANODE_CMD} hadoop fs -put /data/positions.csv /user/automotive
${DOCKER_EXECUTE_DATANODE_CMD} hadoop fs -put /data/trips.csv /user/automotive

${DOCKER_EXECUTE_NAMENODE_CMD} hadoop fs -ls /user/automotive
