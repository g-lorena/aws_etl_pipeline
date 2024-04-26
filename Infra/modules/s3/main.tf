resource "aws_s3_bucket" "etl_bucket"{
  bucket  = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket" "utils_bucket"{
  bucket  = var.utils_bucket_name
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

resource "aws_s3_object" "glue_script" {
  bucket = aws_s3_bucket.utils_bucket.id
  key    = var.glue_script_key
  source = var.glue_local_script_path
  etag = filemd5(var.glue_local_script_path)
}