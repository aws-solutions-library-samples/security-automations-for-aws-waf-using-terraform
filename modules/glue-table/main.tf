resource "aws_glue_catalog_table" "this" {
  name          = var.catalog_table_name
  database_name = var.database_name
  catalog_id    = var.catalog_id
  owner         = var.owner
  parameters    = var.parameters
  partition_keys {
    name = "year"
    type = "int"
  }
  partition_keys {
    name = "month"
    type = "init"
  }
  partition_keys {
    name = "day"
    type = "int"
  }
  partition_keys {
    name = "hour"
    type = "int"
  }

  dynamic "storage_descriptor" {
    for_each = var.storage_descriptor != null ? [true] : []

    content {
      bucket_columns            = try(var.storage_descriptor.bucket_columns, null)
      compressed                = try(var.storage_descriptor.compressed, null)
      input_format              = try(var.storage_descriptor.input_format, null)
      location                  = try(var.storage_descriptor.location, null)
      number_of_buckets         = try(var.storage_descriptor.number_of_buckets, null)
      output_format             = try(var.storage_descriptor.output_format, null)
      parameters                = try(var.storage_descriptor.parameters, null)
      stored_as_sub_directories = try(var.storage_descriptor.stored_as_sub_directories, null)
      dynamic "columns" {
        for_each = var.logs_columns
        content {
          name = columns.key
          type = columns.value
        }
      }
      dynamic "ser_de_info" {
        for_each = try(var.storage_descriptor.ser_de_info, null) != null ? [true] : []

        content {
          name                  = try(var.storage_descriptor.ser_de_info.name, null)
          parameters            = try(var.storage_descriptor.ser_de_info.parameters, null)
          serialization_library = try(var.storage_descriptor.ser_de_info.serialization_library, null)
        }
      }
    }
  }
}