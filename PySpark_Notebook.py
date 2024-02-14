# Databricks notebook source
import pyspark

# COMMAND ----------

from pyspark.sql import SparkSession

# COMMAND ----------

spark=SparkSession.builder.appName('CFD').getOrCreate()

# COMMAND ----------

spark

# COMMAND ----------

workdir = !pwd
file_path=f"file:///{workdir[0]}/data/EURUSD_M1.csv"

# COMMAND ----------

df_pyspark=spark.read.options(header='true', delimiter="\t").csv(file_path)

# COMMAND ----------

df_pyspark.show()

# COMMAND ----------

df_pyspark.printSchema()

# COMMAND ----------

df_pyspark.head()

# COMMAND ----------


