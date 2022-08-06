#!/bin/bash

export TF_VAR_region=ap-south-1
export TF_VAR_created_by=Tushar
export TF_VAR_service="apigw-lambda-app"

yarn build

cd infrastructure/resources

terraform init -input=false

terraform plan

terraform apply -input=false