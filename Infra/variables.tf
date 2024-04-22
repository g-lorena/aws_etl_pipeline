variable "aws_region" {
    default = "eu-west-3"
    description = "AWS Region to deploy to"
}

variable "bucket_name" {
  type        = string
  default     = "real-estate-etl-101"
}

variable "raw_repertory" {
  type        = string
  default     = "raw_data"
}

variable "lambda_layer_bucket_name" {
  type        = string
  default     = "my-lambda-layer-bucket-001"
}

variable "lambda_layer" {
  type        = string
  default     = "lambda_layer"
}

variable "std_repertory" {
  type        = string
  default     = "std_data"
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

variable "rapid_api_key" {
  type        = string
  default     = "c7d66d4175msh4b730460e56d07dp177281jsn66cc27e2b144"
}

variable "rapid_api_host" {
  type        = string
  default     = "zillow56.p.rapidapi.com"
}


