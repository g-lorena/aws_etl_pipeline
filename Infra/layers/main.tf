# create zip file from requirements.txt. Triggers only when the file is updated
resource "null_resource" "lambda_layer" {
  triggers = {
    requirements = filesha1(var.requirements_path)
  }
  # the command to install python and dependencies to the machine and zips
  provisioner "local-exec" {
    command = <<EOT
      set -e
      rm -rf requirements
      mkdir requirements
      pip3 install -r ${var.requirements_path} -t requirements/
      zip -r ${var.layer_zip_path} requirements/
    EOT
  }
}

resource "aws_s3_bucket" "lambda_layer_bucket" {
  bucket = var.lambda_layer_bucket_name
}

resource "aws_s3_object" "lambda_layer_zip" {
    bucket   = aws_s3_bucket.lambda_layer_bucket.id
    key      =  "${var.lambda_layer}/${var.layer_name}/${var.layer_zip_path}"
    source     = var.layer_zip_path
    depends_on = [null_resource.lambda_layer] # triggered only if the zip file is created
    #content_type = "application/x-directory"  
}

# create lambda layer from s3 object
resource "aws_lambda_layer_version" "my-lambda-layer" {
  s3_bucket           = aws_s3_bucket.lambda_layer_bucket.id
  s3_key              = aws_s3_object.lambda_layer_zip.key
  layer_name          = var.layer_name
  compatible_runtimes = var.compatible_layer_runtimes #["python3.10"]
  compatible_architectures = var.compatible_architectures
  skip_destroy        = true
  depends_on          = [aws_s3_object.lambda_layer_zip] # triggered only if the zip file is uploaded to the bucket
}