resource "aws_glue_classifier" "crawler_classifier" {
  name = var.classifier_name

  json_classifier {
    json_path = var.json_path
  }
}