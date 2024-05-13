output "aws_glue_job_name" {
  value = aws_glue_job.immo-glue-job.name
  description = "The name of the Glue ETL Job"
}