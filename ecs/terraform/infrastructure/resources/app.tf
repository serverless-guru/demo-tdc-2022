module "ecs_tf_api" {
  source              = "../modules/ecs-api"
  stage               = var.stage
  ecs_tf_image_tag = var.ecs_tf_image_tag
  region              = var.region
  views_db_name       = module.ddb_table_views.name
  service             = var.service
  kms_key_alias_id    = module.service_kms.alias_name
  created_by          = var.created_by
  tags                = local.tags
}