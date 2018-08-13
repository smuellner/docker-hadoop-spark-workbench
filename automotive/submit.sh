#!/bin/sh
# open port 9000 to access hdfs
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
SPARK_DIR="${DIR}/../tools/bin/spark/bin"
SPARK_SUBMIT="${SPARK_DIR}/spark-submit"
export YARN_CONF_DIR="./etc"

# spark-submit --conf spark.yarn.jars="hdfs://127.0.0.1:/spark/" \
# ${SPARK_SUBMIT} --master spark://127.0.0.1:7077 \
spark-submit --master spark://127.0.0.1:7077 \
--deploy-mode client \
--driver-memory 512m \
--executor-memory 512m \
--executor-cores 2 \
automotive.py
