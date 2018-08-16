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

SPARK_DIR="${DIR}/../tools/bin/spark/bin"
SPARK_SUBMIT="${SPARK_DIR}/spark-submit"
export YARN_CONF_DIR="./etc"

CURRENT_HOST=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | sed -n 1p`
HADOOP_HOST_NAMENODE=${CURRENT_HOST}
PORT=8020
HDFS_URL="hdfs://${HADOOP_HOST_NAMENODE}:${PORT}/user/automotive/"
echo "HADOOP NAMENODE: ${HADOOP_HOST_NAMENODE}"
# ------------- variables --------------------

# ${HADOOP_CMD} fs -rm ${HDFS_URL}/join.txt

sed "s/{HADOOP_HOST_NAMENODE}/${HADOOP_HOST_NAMENODE}/" automotive.py > automotive-runner.py

# spark-submit --conf spark.yarn.jars="hdfs://127.0.0.1:/spark/" \
# ${SPARK_SUBMIT} --master spark://127.0.0.1:7077 \
# ${SPARK_SUBMIT} --master spark://127.0.0.1:7077 \
${SPARK_SUBMIT} --master spark://127.0.0.1:7077 \
--deploy-mode client \
--driver-memory 512m \
--executor-memory 512m \
--executor-cores 2 \
automotive-runner.py

rm automotive-runner.py
