resource "aws_glue_crawler" "ecommerce_crawler" {
  database_name = var.database
  name          = var.name
  role          = var.glue_iam_role

  s3_target {
      path = var.s3_target_path
  }

  #schedule = "cron(0 2 * * ? *)"
}