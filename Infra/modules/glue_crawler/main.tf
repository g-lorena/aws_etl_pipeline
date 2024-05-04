resource "aws_glue_crawler" "houston_crawler" {
  name                  = var.houston_crawler_name
  database_name         = var.database
  role                  = var.glue_iam_role 
  table_prefix          = "immo_" 

  s3_target {
    path = "${var.s3_target_path_houston}${var.houston}"
  }

}

resource "aws_glue_crawler" "panamera_crawler" {
  name                  = var.panamera_crawler_name
  database_name         = var.database
  role                  = var.glue_iam_role 
  table_prefix          = "immo_" 

  s3_target {
    path = "${var.s3_target_path_panamera}${var.panamera}"
  }

}



/*
resource "aws_glue_crawler" "immo_crawler" {
  database_name = var.database
  name          = var.name
  role          = var.glue_iam_role
  table_prefix = "immo_"
  classifiers = var.classifiers
  
  s3_target {
      path = var.s3_target_path
  }

  
  

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
