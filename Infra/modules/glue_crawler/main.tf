resource "aws_glue_crawler" "immo_crawler" {
  database_name = var.database
  name          = var.name
  role          = var.glue_iam_role
  table_prefix = "immo_"
  classifiers = var.classifiers
  
  s3_target {
      path = var.s3_target_path
  }

  
  /*

├───data = raw_data
│   ├───bike_data = panamera
│   │   ├───tbl_bikedata_station
│   │   └───tbl_bikedata_trip
│   ├───br_ecommerce = houston
│   │   ├───tbl_brecommerce_customers
│   │   ├───tbl_brecommerce_geolocation
      = zozo


  s3_target {
      path = var.s3_target_path
  }
 

  dynamic "s3_path" {
    for_each = var.directories

    content {
      path = 
    }
  }
 */
  #schedule = "cron(0 2 * * ? *)"
}