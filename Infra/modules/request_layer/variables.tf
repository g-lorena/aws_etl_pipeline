variable "compatible_architectures" {
  description = "compatible_architectures"
  type        = list(string)
}

variable "compatible_layer_runtimes" {
  description = "compatible_layer_runtimes"
  type        = list(string)
}

variable "requirements_path"{
  description = "requirements path"
  type        = string
}

variable "layer_zip_path"{
  description = "layer zip path"
  type        = string
}

variable "lambda_layer_bucket_name"{
  description = "lambda layer bucket name"
  type        = string
}

variable "layer_name"{
  description = "layer name"
  type        = string
}

variable "lambda_layer"{
  description = "lambda layer"
  type        = string
}


/*
variable "path_to_request_layer_source" {
  description = "request layer source path"
  type        = string
}

variable "path_to_request_layer_artifact" {
  description = "request layer artifact"
  type        = string
}

variable "request_layer_name" {
  description = "layer name"
  type        = string
}

variable "path_to_request_layer_filename" {
  description = "path to request layer filename"
  type        = string
}
*/






