#!/bin/bash

BUCKET_NAME=tushar-sharma-slsguru-tdc-demo-terraform-backend

export TF_VAR_region=ap-south-1
export TF_VAR_created_by=Tushar
export TF_VAR_service="apigw-lambda-tf-app"

yarn build

cd infrastructure/resources

terraform init -input=false

terraform destroy -input=false -auto-approve

cd ../..

rm -rf dist
rm -rf infrastructure/modules/lambda/tmp
rm -rf infrastructure/resources/.terraform
rm infrastructure/resources/.terraform.lock.hcl