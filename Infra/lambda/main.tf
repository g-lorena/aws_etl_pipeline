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