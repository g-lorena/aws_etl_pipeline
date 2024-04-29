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

  # layer
  layer_zip_path    = "requirements.zip"
  layer_name        = "my_lambda_requirements_layer"
  requirements_path = "../requirements.txt"
  
  compatible_layer_runtimes = ["python3.10"]
  compatible_architectures  = ["x86_64"]

  # lambda 
  path_to_source_file = "../etl/extract/extract_data.py"
  path_to_output    = "lambda_function_extract_data.zip"
  function_name       = "lambda_extract_fromAPI"
  function_handler    = "extract_data.lambda_handler"
  memory_size         = 512
  timeout             = 300
  runtime             = "python3.10"

}