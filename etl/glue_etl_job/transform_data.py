import sys

from awsglue.context import GlueContext
from awsglue.dynamicframe import DynamicFrame
from awsglue.job import Job
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark.sql import functions as F
from pyspark.sql.functions import col, expr, first

sc = SparkContext.getOrCreate()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)


def extract_houston_from_catalog(database, houston_table_name):
    raw_houston_dynamic_frame = glueContext.create_dynamic_frame.from_catalog(
        database=database, table_name=houston_table_name
    )
    df = raw_houston_dynamic_frame.toDF()
    return df


def extract_pasadena_from_catalog(database, pasadena_table_name):
    raw_pasadena_dynamic_frame = glueContext.create_dynamic_frame.from_catalog(
        database=database, table_name=pasadena_table_name
    )
    df = raw_pasadena_dynamic_frame.toDF()
    return df


def load_to_s3(glue_dynamic_frame):
    s3output = glueContext.getSink(
        path="s3://real-estate-etl-101/std_data/",
        connection_type="s3",
        updateBehavior="UPDATE_IN_DATABASE",
        partitionKeys=[],
        compression="snappy",
        enableUpdateCatalog=True,
        transformation_ctx="s3output",
    )

    s3output.setCatalogInfo(
        catalogDatabase="ecommerce-database", catalogTableName="mart"
    )

    s3output.setFormat("glueparquet")
    s3output.writeFrame(glue_dynamic_frame)


if __name__ == "__main__":
    df_houston = extract_houston_from_catalog()

    df_pasadena = extract_pasadena_from_catalog
    # going from Spark dataframe to glue dynamic frame
    glue_dynamic_frame = DynamicFrame.fromDF(df_pasadena, glueContext, "glue_etl")

    # load to s3

    job.commit()
