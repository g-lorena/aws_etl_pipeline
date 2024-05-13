module "s3bucket" {
  source = "./modules/s3"

  bucket_name   = local.bucket_name
  raw_repertory = local.raw_repertory
  std_repertory = local.std_repertory

  utils_bucket_name      = local.utils_bucket
  glue_script_key        = local.glue_script_key
  glue_local_script_path = local.glue_local_script_path

}

module "lambdaLayer" {
  source = "./modules/request_layer"

  requirements_path = local.requirements_path
  layer_zip_path    = local.layer_zip_path
  layer_name        = local.layer_name

  path_to_system_folder = local.path_to_system_folder

  lambda_layer_bucket_name = local.lambda_layer_bucket_name
  lambda_layer             = local.lambda_layer

  #path_to_request_layer_source = local.path_to_request_layer_source
  #path_to_request_layer_artifact = local.path_to_request_layer_artifact

  #path_to_request_layer_filename = local.path_to_request_layer_filename
  #request_layer_name = local.request_layer_name


  #path_to_request_layer_source = local.path_to_request_layer_source
  #path_to_request_layer_artifact = local.path_to_request_layer_artifact

  #path_to_request_layer_filename = local.path_to_request_layer_filename
  #request_layer_name = local.request_layer_name

  compatible_layer_runtimes = local.compatible_layer_runtimes
  compatible_architectures  = local.compatible_architectures

}

module "lambdaFunction" {
  source = "./modules/lambda"

  path_to_source_folder = local.path_to_source_folder
  path_to_output        = local.path_to_output
  function_name         = local.function_name
  function_handler      = local.function_handler
  memory_size           = local.memory_size
  timeout               = local.timeout
  runtime               = local.runtime
  rapid_api_host        = local.rapid_api_host
  rapid_api_key         = local.rapid_api_key
  bucket_name           = local.bucket_name
  raw_repertory         = local.raw_repertory
  lambda_layer_arns     = [module.lambdaLayer.lamnda_layer_arn]
  aws_region            = local.aws_region
  s3_bucket_arn         = module.s3bucket.s3_etl_bucket_arn

}

module "cloudwatch_schedule_module" {
  source                   = "./modules/eventbridge"
  schedule_name            = local.schedule_name
  schedule_value           = local.schedule_value
  aws_lambda_arn           = module.lambdaFunction.lambda_function_arn
  aws_lambda_function_name = module.lambdaFunction.lambda_function_name
}

module "glueCatalogDatabase" {
  source = "./modules/glue_catalog_database"

  glue_catalog_database_name = local.glue_catalog_database_name
}

module "glueIamRole" {
  source = "./modules/glue_iam"

}

module "glueClassifier" {
  source          = "./modules/glue_classifier"
  classifier_name = local.classifier_name
  json_path       = local.json_path

}

module "glueCrawler" {
  source = "./modules/glue_crawler"

  database              = module.glueCatalogDatabase.database_name
  houston_crawler_name  = local.houston_crawler_name
  panamera_crawler_name = local.panamera_crawler_name

  houston  = local.houston
  panamera = local.panamera

  #name = local.glue_Crawler_Name
  glue_iam_role = module.glueIamRole.glue_iam_arn

  classifiers             = [module.glueClassifier.aws_glue_classifier_id]
  s3_target_path_panamera = module.s3bucket.aws_s3_bucket_uri
  s3_target_path_houston  = module.s3bucket.aws_s3_bucket_uri
  #s3_target_path = module.s3bucket.aws_s3_bucket_uri
}

module "glueJob" {
  source = "./modules/glue_job"

  name         = local.glue_job_name
  iam_glue_arn = module.glueIamRole.glue_iam_arn
  glue_version = local.glue_version
  #worker_type = local.worker_type
  script_location         = module.s3bucket.aws_s3_bucket_glue_script_uri
  timeout                 = local.time_out
  class                   = local.class
  enable-job-insights     = local.enable-job-insights
  enable-auto-scaling     = local.enable-auto-scaling
  enable-glue-datacatalog = local.enable-glue-datacatalog
  job-language            = local.job-language
  job-bookmark-option     = local.job-bookmark-option
  datalake-formats        = local.datalake-formats
  conf                    = local.conf

}

module "glueTrigger" {
  source = "./modules/glue_trigger"

  name           = local.glue_trigger_name
  schedule_type  = local.glue_trigger_schedule_type
  schedule_value = local.schedule_value
  job_name       = module.glueJob.aws_glue_job_name
}




/*
### lambda 

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
  
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

#define variables
locals {
  layer_zip_path    = "requirements.zip"
  layer_name        = "my_lambda_requirements_layer"
  requirements_path = "../requirements.txt"
}

# create zip file from requirements.txt. Triggers only when the file is updated
resource "null_resource" "lambda_layer" {
  triggers = {
    requirements = filesha1(local.requirements_path)
  }
  # the command to install python and dependencies to the machine and zips
  provisioner "local-exec" {
    command = <<EOT
      set -e
      rm -rf requirements
      mkdir requirements
      pip3 install -r ${local.requirements_path} -t requirements/
      zip -r ${local.layer_zip_path} requirements/
    EOT
  }
}

resource "aws_s3_bucket" "lambda_layer_bucket" {
  bucket = var.lambda_layer_bucket_name
}

resource "aws_s3_object" "lambda_layer_zip" {
    bucket   = aws_s3_bucket.lambda_layer_bucket.id
    key      =  "${var.lambda_layer}/${local.layer_name}/${local.layer_zip_path}"
    source     = local.layer_zip_path
    depends_on = [null_resource.lambda_layer] # triggered only if the zip file is created
    #content_type = "application/x-directory"  
}

# create lambda layer from s3 object
resource "aws_lambda_layer_version" "my-lambda-layer" {
  s3_bucket           = aws_s3_bucket.lambda_layer_bucket.id
  s3_key              = aws_s3_object.lambda_layer_zip.key
  layer_name          = local.layer_name
  compatible_runtimes = ["python3.10"]
  skip_destroy        = true
  depends_on          = [aws_s3_object.lambda_layer_zip] # triggered only if the zip file is uploaded to the bucket
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_policy" {
#name        = "lambda_s3"
#description = "lambda_policy_s3"
statement {
    effect    = "Allow"
    actions   = ["s3:GetObject","s3:ListBucket"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda-policy"
  description = "allow lambda to get and list object into the bucket"
  policy      = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_getObject" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "../etl/extract/extract_data.py"
  output_path = "lambda_function_extract_data.zip"
}

resource "aws_lambda_function" "lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_function_extract_data.zip"
  function_name = "lambda_extract_fromAPI"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "extract_data.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.10"
  layers = [aws_lambda_layer_version.my-lambda-layer.arn]

  #s3_bucket = var.bucket_name
  #s3_key = aws_s3_object.lambda_layer_zip.key

  environment {
    variables = {
      API_KEY = var.rapid_api_key
      API_HOST = var.rapid_api_host
      DST_BUCKET = var.bucket_name
      REGION = var.aws_region
      RAW_FOLDER = var.raw_repertory
    }
  }
}

resource "aws_s3_bucket" "etl_bucket"{
  bucket  = var.bucket_name
  force_destroy = true
}

resource "aws_s3_object" "raw_zone" {
    bucket   = aws_s3_bucket.etl_bucket.id
    acl = "private"
    key      =  "${var.raw_repertory}/"
    content_type = "application/x-directory"  
}

resource "aws_s3_object" "std_zone" {
    bucket   = aws_s3_bucket.etl_bucket.id
    acl = "private"
    key      =  "${var.std_repertory}/"
    content_type = "application/x-directory"  
}

resource "aws_lambda_permission" "s3" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "s3.amazonaws.com"

  source_arn = "arn:aws:s3:::${var.bucket_name}/*"
}
#### fin first part 


resource "aws_s3_bucket" "raw_bucket"{
  bucket = aws_s3_bucket.etl_bucket.id
  key    = var.raw_data_key
  
}

resource "aws_s3_object" "raw_customer" {
  bucket = aws_s3_bucket.etl_bucket.id
  key    = var.raw_data_customer_key
  source = var.raw_customer_data_local_path
}

resource "aws_s3_object" "raw_item" {
  bucket = aws_s3_bucket.etl_bucket.id
  key    = var.raw_data_item_key
  source = var.raw_item_data_local_path
}

resource "aws_s3_object" "raw_store" {
  bucket = aws_s3_bucket.etl_bucket.id
  key    = var.raw_data_store_key
  source = var.raw_store_data_local_path
}

resource "aws_s3_object" "raw_time" {
  bucket = aws_s3_bucket.etl_bucket.id
  key    = var.raw_data_time_key
  source = var.raw_time_data_local_path
}

resource "aws_s3_object" "raw_transaction" {
  bucket = aws_s3_bucket.etl_bucket.id
  key    = var.raw_data_transaction_key
  source = var.raw_transaction_data_local_path
}


resource "aws_iam_role" "glue_role" {
  name = "glue_role_etl"
  assume_role_policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
      {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Sid    = ""
          Principal = {
          Service = "glue.amazonaws.com"
          }
      },
      ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole" ,"arn:aws:iam::aws:policy/AmazonS3FullAccess"]
}

resource "aws_glue_catalog_database" "ecommerce-etl-database" {
  name = var.database_name
}

resource "aws_glue_crawler" "ecommerce_crawler" {
  database_name = aws_glue_catalog_database.ecommerce-etl-database.name
  name          = "ecommerce-data"
  role          = aws_iam_role.glue_role.arn

  s3_target {
      path = "s3://${aws_s3_bucket.etl_bucket.bucket}/${var.path_to_data_key}"
  }
}

resource "aws_s3_object" "glue_script" {
  bucket = aws_s3_bucket.etl_bucket.id
  key    = var.script_key
  source = var.local_glue_script
}

resource "aws_glue_job" "ecommerce-etl-job" {
  name     = "ecommerce-etl-job"
  role_arn = aws_iam_role.glue_role.arn
  glue_version = "4.0"
  worker_type  = "G.1X"
  number_of_workers = 2
  timeout = 2880

  command {
      script_location = "s3://${aws_s3_bucket.etl_bucket.bucket}/${var.script_key}"
  }
}
*/