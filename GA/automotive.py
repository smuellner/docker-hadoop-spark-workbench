from pyspark import SparkContext, SparkConf
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, expr, when
import pyspark.sql.functions as func

###### Variables
datanode = "{HADOOP_HOST_NAMENODE}"
targetFolder = "/user/GA/"
src1Folder = "/user/GA/SRC1"
src2Folder = "/user/GA/SRC2"
csvDelimiter = ";"
######

sc = SparkContext(appName = "GA")
spark = SparkSession \
    .builder \
    .appName("GA") \
    .getOrCreate()

######
# Get fs handler from java gateway
######
HDFSNode = "hdfs://" + datanode
URI = sc._gateway.jvm.java.net.URI
Path = sc._gateway.jvm.org.apache.hadoop.fs.Path
FileSystem = sc._gateway.jvm.org.apache.hadoop.fs.FileSystem
fs = FileSystem.get(URI(HDFSNode), sc._jsc.hadoopConfiguration())
# We can now use the Hadoop FileSystem API (https://hadoop.apache.org/docs/current/api/org/apache/hadoop/fs/FileSystem.html)
print("#########################################################################")
print("# HDFS NODE: " + HDFSNode)
print("#########################################################################")
print("########################    PROCESSING    ###############################")
print("#########################################################################")

files = fs.listStatus(Path(src1Folder))

for file in files:
    print("-------------------------------------------------------------------------")
    filename = file.getPath().getName()
    targetFile = Path(targetFolder + "/" + filename)
    if fs.exists(targetFile):
        fs.delete(targetFile, True)
    print("FILE: " + filename)
    print("-------------------------------------------------------------------------")
    # join the dataframes
    src1 = spark.read.option("sep", csvDelimiter).csv(HDFSNode + src1Folder + "/" + filename, header=True, mode="DROPMALFORMED")
    src1 = src1.withColumnRenamed("time", "time1");
    src1Join = src1.withColumn("join_on_time1", func.round(src1.time1, 1))
    src2 = spark.read.option("sep", csvDelimiter).csv(HDFSNode + src2Folder + "/" + filename, header=True, mode="DROPMALFORMED")
    src2 = src2.withColumnRenamed("time", "time2");
    src2Join = src2.withColumn("join_on_time2", func.round(src2.time2, 1))
    joined = src1Join.join(src2Join, src1Join.join_on_time1 == src2Join.join_on_time2, how='left_outer')
    joined.write.format("csv").save("hdfs://" + datanode + targetFolder + "/" + filename, header = 'true')
    print("-------------------------------------------------------------------------")

print("#########################################################################")
print("#########################################################################")

spark.stop()
