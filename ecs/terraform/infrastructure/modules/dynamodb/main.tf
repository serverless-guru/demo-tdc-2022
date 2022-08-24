locals {
  ttl = (var.ttl == true ? [
    {
      ttl_enable = var.ttl
    }
  ] : [])
  range_keys = compact([
    for item in var.global_secondary_indexes : try(item.range_key, null)
  ])
  hash_keys = compact([
    for item in var.global_secondary_indexes : try(item.hash_key, null)
  ])
  tags = merge(var.tags,
    {
      Name = var.db_name
  })
}

resource "aws_dynamodb_table" "table" {
  name             = "${var.db_name}-${var.stage}"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = var.pk_name
  range_key        = var.sk_name
  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_enabled ? "NEW_AND_OLD_IMAGES" : null


  dynamic "server_side_encryption" {
    for_each = var.kms_key_arn != "" ? [true] : []
    content {
      enabled     = true
      kms_key_arn = var.kms_key_arn
    }
  }
  attribute {
    name = var.pk_name
    type = "S"
  }

  attribute {
    name = var.sk_name
    type = "S"
  }

  dynamic "ttl" {
    for_each = local.ttl
    content {
      enabled        = local.ttl[0].ttl_enable
      attribute_name = "TTL"
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes

    content {
      name               = "GSI${global_secondary_index.key + 1}"
      hash_key           = global_secondary_index.value.hash_key
      projection_type    = lookup(global_secondary_index.value, "projection_type", "ALL")
      range_key          = lookup(global_secondary_index.value, "range_key", null)
      read_capacity      = lookup(global_secondary_index.value, "read_capacity", 0)
      write_capacity     = lookup(global_secondary_index.value, "write_capacity", 0)
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", [])
    }
  }

  dynamic "attribute" {
    for_each = local.hash_keys
    content {
      name = attribute.value
      type = "S"
    }
  }
  dynamic "attribute" {
    for_each = local.range_keys
    content {
      name = attribute.value
      type = "S"
    }
  }

  tags = local.tags
}
