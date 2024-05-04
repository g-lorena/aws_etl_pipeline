output "aws_glue_houston_crawler_name" {
  value = aws_glue_crawler.houston_crawler.name
  description = "The name of the Glue Crawler"
}

output "aws_glue_panamera_crawler_name" {
  value = aws_glue_crawler.panamera_crawler.name
  description = "The name of the Glue Crawler"
}