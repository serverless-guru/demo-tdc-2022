#!/bin/bash

export CDK_DEFAULT_REGION=ap-south-1
export CDK_DEFAULT_ACCOUNT="935443220863"

yarn build:app

cdk bootstrap "aws://${CDK_DEFAULT_ACCOUNT}/${CDK_DEFAULT_REGION}" --require-approval never

cdk deploy apigw-lambda-cdk-app --require-approval never

rm -rf dist
