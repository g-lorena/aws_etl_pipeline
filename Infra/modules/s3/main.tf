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