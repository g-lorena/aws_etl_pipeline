locals {
  
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
  runtime             = "python3.7"

}