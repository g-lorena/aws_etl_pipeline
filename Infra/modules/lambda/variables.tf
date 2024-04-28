variable "rapid_api_key" {
  description = "Rapid API Key"
  type        = string
  #default     = "c7d66d4175msh4b730460e56d07dp177281jsn66cc27e2b144"
}

variable "rapid_api_host" {
  description = "Rapid API Host"
  type        = string
  #default     = "zillow56.p.rapidapi.com"
}

variable "aws_region" {
  description = "AWS Region to deploy to"
  type        = string
  #default = "eu-west-3"
}

variable "bucket_name" {
  description = "principal bucket name"
  type        = string
  #default     = "real-estate-etl-101"
}

variable "raw_repertory" {
  description = "raws data repertory"
  type        = string
  #default     = "raw_data"
}

variable "lambda_layer_arns" {
  description = "lambda_layer_arns"
  type        = list(string)
}

variable "runtime" {
  description = "Lambda Runtime"
  type        = string
}

variable "function_handler" {
  description = "Name of Lambda Function Handler"
  type        = string
}

variable "function_name" {
  description = "Name of Lambda Function"
  type        = string
}
/*
variable "path_to_source_file" {
  description = "Path to Lambda Fucntion Source Code"
  type        = string
}
*/
variable "path_to_source_folder" {
  description = "Path to Lambda Fucntion Source Code"
  type        = string
}

variable "path_to_output" {
  description = "Path to ZIP artifact"
  type        = string
}

variable "memory_size" {
  description = "Lambda Memory"
  type        = number
}

variable "timeout" {
  description = "Lambda Timeout"
  type        = number
}

variable "s3_bucket_arn" {
  description = "lambda_layer_arns"
  type        = string
}