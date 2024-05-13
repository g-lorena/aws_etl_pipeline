resource "aws_glue_catalog_table" "glue_catalog_table" {
  name = var.table-name
  database_name = var.database_name
}
