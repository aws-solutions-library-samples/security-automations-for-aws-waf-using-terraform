resource "aws_glue_catalog_database" "glue_database" {
  name       = var.name
  catalog_id = var.catalog_id
}