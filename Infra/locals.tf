locals {
  
  #buckets 
  lambda_layer_bucket_name = "my-lambda-layer-bucket-001"
  lambda_layer = "lambda_layer"
  rapid_api_host = "zillow56.p.rapidapi.com"
  rapid_api_key = "c7d66d4175msh4b730460e56d07dp177281jsn66cc27e2b144"
  bucket_name = "real-estate-etl-101"
  raw_repertory = "raw_data"
  std_repertory = "std_data"
  aws_region = "eu-west-3"

  utils_bucket = "real-estate-etl-utils"
  glue_script_key = "script/glue_etl_script.py"
  glue_local_script_path = "../etl/glue_etl_job/transform_data.py"


  # first method layer
  layer_zip_path    = "python.zip"
  layer_name        = "my_lambda_requirements_layer"
  requirements_path = "../requirements.txt"
  path_to_system_folder = "../etl/extract/System"

  # second method => requests layer
  
  #request_layer_name = "requests"
  #path_to_request_layer_filename = "../python.zip"

  #path_to_request_layer_artifact = "./lambda-layer-requests-python3.9-x86_64.zip"
  #path_to_request_layer_source = "requests"
  
  compatible_layer_runtimes = ["python3.10"]
  compatible_architectures  = ["x86_64"]

  # lambda 
  path_to_source_file = "../etl/extract"
  path_to_output    = "lambda_function_extract_data.zip"
  function_name       = "lambda_extract_fromAPI"
  function_handler    = "extract_data.lambda_handler"
  memory_size         = 512
  timeout             = 300
  runtime             = "python3.10"

  # Glue catalog
  glue_catalog_database_name = "real-estate-database"

  # iam

  # Glue Crawler
  glue_Crawler_Name = "real_estate_crawler"

  # Glue Classifier
  classifier_name = "real_estate_classifier"
  json_path = "$[*]"

  # Glue Job
  glue_job_name = "real_estate_job"
  glue_version = "4.0"
  worker_type = "G.1X"
  number_of_workers = 2
  time_out = 2880
  script_location = ""
  class = "GlueApp"
  enable-job-insights = "true"
  enable-auto-scaling = "false"
  enable-glue-datacatalog = "true"
  job-language = "python"
  job-bookmark-option = "job-bookmark-disable"
  datalake-formats = "iceberg"
  conf = "spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions  --conf spark.sql.catalog.glue_catalog=org.apache.iceberg.spark.SparkCatalog  --conf spark.sql.catalog.glue_catalog.warehouse=s3://tnt-erp-sql/ --conf spark.sql.catalog.glue_catalog.catalog-impl=org.apache.iceberg.aws.glue.GlueCatalog  --conf spark.sql.catalog.glue_catalog.io-impl=org.apache.iceberg.aws.s3.S3FileIO"
  
  # cloudwatch
  schedule_name = "schedule"
  schedule_value = "cron(0 8 ? * MON-FRI *)"
}