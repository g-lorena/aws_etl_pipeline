resource "aws_glue_catalog_database" "aws_glue_catalog_database" {
  name = var.glue_catalog_database_name
}

/*
resource "aws_glue_catalog_table" "location" {
  name = "MyCatalogTable"
  database_name = aws_glue_catalog_database.aws_glue_catalog_database.name
}
*/