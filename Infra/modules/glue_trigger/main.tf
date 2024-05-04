resource "aws_glue_trigger" "gluejob-trigger" {
  name     = var.name
  schedule = var.schedule_value #"cron(15 12 * * ? *)"
  type     = var.schedule_type #"SCHEDULED"

  actions {
    job_name = var.job_name
  }
}