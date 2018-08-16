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

SPARK_DIR="${DIR}/../tools/bin/spark/bin"
SPARK_SUBMIT="${SPARK_DIR}/spark-submit"
export YARN_CONF_DIR="./etc"

# ------------- variables --------------------

# spark-submit --conf spark.yarn.jars="hdfs://127.0.0.1:/spark/" \
# ${SPARK_SUBMIT} --master spark://127.0.0.1:7077 \
# ${SPARK_SUBMIT} --master spark://127.0.0.1:7077 \
spark-submit --master spark://127.0.0.1:7077 \
--deploy-mode client \
--driver-memory 512m \
--executor-memory 512m \
--executor-cores 2 \
automotive.py
