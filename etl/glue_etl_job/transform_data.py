import sys
from awsglue.transforms import *
from pyspark.sql import functions as F
from pyspark.sql.functions import col, first, expr
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.dynamicframe import DynamicFrame
from awsglue.job import Job

sc = SparkContext.getOrCreate()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)

def create_df_froms3():
    dyf = glueContext.create_dynamic_frame.from_catalog(database='ecommerce-database', table_name='customer')
    df = dyf.toDF()
    return df

if __name__ == "__main__":
    df = create_df_froms3()
    
    # going from Spark dataframe to glue dynamic frame
    glue_dynamic_frame = DynamicFrame.fromDF(df, glueContext, "glue_etl")


    # load to s3
    s3output = glueContext.getSink(
    path="s3://cecommerce-etl/report/",
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
    job.commit()