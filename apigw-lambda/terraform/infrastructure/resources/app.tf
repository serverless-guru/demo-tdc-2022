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

# Lambdas
resource "aws_cloudwatch_event_rule" "refresh_api_token_lambda_rule" {
  name                = "hello-world"
  description         = "refreshed gem api token for ${var.service}"
  schedule_expression = "rate(5 minutes)"
  depends_on          = [module.refresh_api_token_lambda]
}

resource "aws_cloudwatch_event_target" "refresh_api_token_lambda_target" {
  rule      = aws_cloudwatch_event_rule.refresh_api_token_lambda_rule.name
  target_id = module.refresh_api_token_lambda.name
  arn       = module.refresh_api_token_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.refresh_api_token_lambda.name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.refresh_api_token_lambda_rule.arn
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
