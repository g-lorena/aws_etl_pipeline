output "s3_etl_bucket_arn"{
    value = aws_s3_bucket.etl_bucket.arn
}

output "s3_utils_bucket_arn"{
    value = aws_s3_bucket.utils_bucket.arn
}

output "aws_s3_bucket_uri" {
  value = "${aws_s3_bucket.etl_bucket.bucket}/${aws_s3_object.raw_zone.key}"
}

output "aws_s3_bucket_glue_script_uri" {
  value = "${aws_s3_bucket.utils_bucket.bucket}/${aws_s3_object.glue_script.key}"
}