
resource "aws_glue_job" "immo-glue-job" {
  name     = var.name
  role_arn = var.iam_glue_arn
  glue_version = var.glue_version #"4.0"
  worker_type  = var.worker_type #"G.1X"
  number_of_workers = var.number_of_workers #2
  timeout = var.timeout #2880

  command {
      script_location = var.script_location
  }
}