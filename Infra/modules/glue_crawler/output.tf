output "aws_glue_crawler_name" {
  value = aws_glue_crawler.immo_crawler.name
  description = "The name of the Glue Crawler"
}