#!/usr/bin/env node
import 'source-map-support/register';

import * as cdk from 'aws-cdk-lib';

import { NetworkStack } from '../lib/networking-stack';
import { EcsService } from '../lib/ecs-service';

const app = new cdk.App();

const newtorkStack = new NetworkStack(app, 'ecs-cdk-network', {
  env: { account: process.env.CDK_DEFAULT_ACCOUNT, region: process.env.CDK_DEFAULT_REGION },
});

new EcsService(app, 'ecs-cdk-service', {
  vpc: newtorkStack.vpc,
  env: { account: process.env.CDK_DEFAULT_ACCOUNT, region: process.env.CDK_DEFAULT_REGION },
}).addDependency(newtorkStack)
