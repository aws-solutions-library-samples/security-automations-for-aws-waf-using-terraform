output "name" {
  value = join(",", aws_glue_catalog_table.this.*.name)
}