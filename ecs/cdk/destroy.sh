#!/bin/bash

export CDK_DEFAULT_REGION=ap-south-1
export CDK_DEFAULT_ACCOUNT="935443220863"

yarn build:app

cdk destroy ecs-cdk-app

rm -rf dist
