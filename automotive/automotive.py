from pyspark import SparkContext, SparkConf
from pyspark.sql import SparkSession

spark = SparkSession \
    .builder \
    .appName("Automotive") \
    .getOrCreate()

accelerations = spark.read.csv("hdfs://192.168.0.104/user/automotive/accelerations.csv", header=True, mode="DROPMALFORMED")
print(accelerations.collect())
