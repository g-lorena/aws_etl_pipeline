variable "aws_region" {
    default = "eu-west-3"
    description = "AWS Region to deploy to"
}

variable "lambda_layer_bucket_name" {
  type        = string
  default     = "my-lambda-layer-bucket-001"
}

variable "lambda_layer" {
  type        = string
  default     = "lambda_layer"
}

variable "raw_data_key" {
  type        = string
  default     = "raw_data/"
}

variable "database_name" {
  type        = string
  default     = "ecommerce-database"
}

variable "local_glue_script" {
  type        = string
  default     = "../glue_etl_job/glue_etl_spark.py"
}

variable "script_key" {
  type        = string
  default     = "script/glue_etl_script.py"
}

variable "path_to_data_key" {
  type        = string
  default     = "raw_data"
}




