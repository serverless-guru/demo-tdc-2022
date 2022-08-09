#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import { CdkCfS3Stack } from '../lib/cdk-cf-s3-stack'

const app = new cdk.App();

new CdkCfS3Stack(app, 'CdkCfS3Stack', {
  env: {
    account: process.env.CDK_DEFAULT_ACCOUNT,
    region: process.env.CDK_DEFAULT_REGION,
  },
  domainName:'serverlessguru.danielmuller.me',
  siteSubDomain:'cf-s3-demo-cdk',
});
