
resource "aws_glue_job" "immo-glue-job" {
  name     = var.name
  role_arn = var.iam_glue_arn
  glue_version = var.glue_version #"4.0"
  #worker_type  = var.worker_type #"G.1X"
  #number_of_workers = var.number_of_workers #2
  timeout = var.timeout #2880

  command {
      script_location = var.script_location
  }

  default_arguments = {
    "--class"                   = var.class #"GlueApp"
    "--enable-job-insights"     = var.enable-job-insights #"true"
    "--enable-auto-scaling"     = var.enable-auto-scaling #"false"
    "--enable-glue-datacatalog" = var.enable-glue-datacatalog #"true"
    "--job-language"            = var.job-language #"python"
    "--job-bookmark-option"     = var.job-bookmark-option #"job-bookmark-disable"
    "--datalake-formats"        = var.datalake-formats #"iceberg"
    "--conf"                    = var.conf #"spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions  --conf spark.sql.catalog.glue_catalog=org.apache.iceberg.spark.SparkCatalog  --conf spark.sql.catalog.glue_catalog.warehouse=s3://tnt-erp-sql/ --conf spark.sql.catalog.glue_catalog.catalog-impl=org.apache.iceberg.aws.glue.GlueCatalog  --conf spark.sql.catalog.glue_catalog.io-impl=org.apache.iceberg.aws.s3.S3FileIO"
  }
}