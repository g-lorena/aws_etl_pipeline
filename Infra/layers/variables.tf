variable "lambda_layer_bucket_name" {
  description = "lambda layer bucket name"
  type        = string
  #default     = "my-lambda-layer-bucket-001"
}

variable "lambda_layer" {
  description = "lambda layer repertory"
  type        = string
 # default     = "lambda_layer"
}

variable "compatible_architectures" {
  description = "compatible_architectures"
  type        = list(string)
}

variable "compatible_layer_runtimes" {
  description = "compatible_layer_runtimes"
  type        = list(string)
}