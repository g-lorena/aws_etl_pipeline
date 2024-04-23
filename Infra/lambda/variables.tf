variable "rapid_api_key" {
  type        = string
  default     = "c7d66d4175msh4b730460e56d07dp177281jsn66cc27e2b144"
}

variable "rapid_api_host" {
  type        = string
  default     = "zillow56.p.rapidapi.com"
}

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