resource "aws_glue_crawler" "immo_crawler" {
  database_name = var.database
  name          = var.name
  role          = var.glue_iam_role
  table_prefix = "immo_"
  classifiers = var.classifiers
  
  s3_target {
      path = var.s3_target_path
  }

  #schedule = "cron(0 2 * * ? *)"
}