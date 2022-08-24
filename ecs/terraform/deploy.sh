#!/bin/bash

export TF_VAR_region=ap-south-1
export TF_VAR_created_by=Tushar
export TF_VAR_service="ecs-tf"

yarn build

cd infrastructure/resources

terraform init -input=false

terraform apply -input=false -auto-approve

cd ../..

rm -rf dist
rm -rf infrastructure/modules/lambda/tmp
rm -rf infrastructure/resources/.terraform
rm infrastructure/resources/.terraform.lock.hcl