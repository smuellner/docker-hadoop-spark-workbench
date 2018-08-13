from pyspark import SparkContext, SparkConf
from pyspark.sql import SparkSession

spark = SparkSession \
    .builder \
    .appName("Automotive") \
    .getOrCreate()

# join the dataframes
accelerations = spark.read.csv("hdfs://192.168.0.104/user/automotive/accelerations.csv", header=True, mode="DROPMALFORMED").rdd
rdd = accelerations.map(lambda x: (x['trip_id'], x[1:])).groupByKey().mapValues(list).collect().rdd

# gyroscopes = spark.read.csv("hdfs://192.168.0.104/user/automotive/gyroscopes.csv", header=True, mode="DROPMALFORMED")
# joined = accelerations.join(gyroscopes, on=['trip_id', 'timestamp'], how='left_outer').rdd
# positions = spark.read.csv("hdfs://192.168.0.104/user/automotive/positions.csv", header=True, mode="DROPMALFORMED")
# rdd = joined.join(positions, on=['trip_id', 'timestamp'], how='left_outer').rdd
# rdd = rdd.map(lambda x: (x[0], x[1:])).groupByKey().mapValues(list).collect()
rdd.saveAsTextFile("hdfs://192.168.0.104/user/automotive/join.txt")
#accelerations.saveAsHadoopFile("hdfs://192.168.0.104/user/automotive/a.txt", "org.apache.hadoop.mapred.TextOutputFormat")
spark.stop()
