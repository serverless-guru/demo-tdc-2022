data "aws_caller_identity" "current" {}

# VPC
module "tdc_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "tushar-sharma-tdc-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true

  tags = local.tags
}


# API Gateway API

module "hello_world_api" {
  source     = "../modules/apigw-api"
  region     = var.region
  service    = var.service
  created_by = var.created_by
  tags       = local.tags
  stage      = "dev"
  name       = "hello-world"
}

# API Gateway Common Routes

module "hello_world_api_route_part_v1" {
  source     = "../modules/apigw-route-part"
  region     = var.region
  service    = var.service
  created_by = var.created_by
  tags       = local.tags
  parent_id  = module.hello_world_api.root_resource_id
  path_name  = "v1"
  api_gw_id  = module.hello_world_api.id
}

## Lambda Integration (/v1/test) ##

module "hello_world_api_route_part_v1_test" {
  source     = "../modules/apigw-route-part"
  region     = var.region
  service    = var.service
  created_by = var.created_by
  tags       = local.tags
  parent_id  = module.hello_world_api_route_part_v1.resource_id
  path_name  = "test"
  api_gw_id  = module.hello_world_api.id
}

module "refresh_api_token_lambda" {
  source     = "../modules/lambda"
  region     = var.region
  service    = var.service
  created_by = var.created_by
  tags       = local.tags
  subnet_ids = module.tdc_vpc.public_subnets
  vpc_id     = module.tdc_vpc.vpc_id
  func_name  = "hello-world"
}

module "hello_world_api_route_handler_v1_test" {
  source            = "../modules/apigw-route-handler"
  region            = var.region
  service           = var.service
  created_by        = var.created_by
  tags              = local.tags
  accountId         = data.aws_caller_identity.current.account_id
  resource_id       = module.hello_world_api_route_part_v1_test.resource_id
  api_gw_id         = module.hello_world_api.id
  http_method       = "GET"
  resource_path     = module.hello_world_api_route_part_v1_test.resource_path
  lambda_invoke_arn = module.refresh_api_token_lambda.invoke_arn
  lambda_func_name  = module.refresh_api_token_lambda.name
}

##### END Lambda Integration (/v1/test) #####
