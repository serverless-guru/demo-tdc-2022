import type { Construct } from 'constructs';

import { join } from 'path';

import { Stack, type StackProps } from 'aws-cdk-lib';

import * as ec2 from 'aws-cdk-lib/aws-ec2';
import * as lambdas from 'aws-cdk-lib/aws-lambda';
import * as apigateway from 'aws-cdk-lib/aws-apigateway';
import * as signer from 'aws-cdk-lib/aws-signer';

export class CdkStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const vpc = new ec2.Vpc(this, 'TheVPC', {
      cidr: '10.0.0.0/16',
      vpcName: 'apigw-lambda-cdk-app-vpc',
      availabilityZones: ['ap-south-1a', 'ap-south-1b', 'ap-south-1c'],
      maxAzs: 3,
      natGateways: 1,
      subnetConfiguration: [
        {
          subnetType: ec2.SubnetType.PRIVATE_WITH_NAT,
          cidrMask: 24,
          name: 'private-with-nat',
        },
        {
          subnetType: ec2.SubnetType.PUBLIC,
          cidrMask: 24,
          name: 'public',
        },
      ],
    });

    const api = new apigateway.RestApi(this, 'books-api', {
      deploy: true,
      restApiName: 'hello-world',
      deployOptions: {
        stageName: 'dev',
      },
      // policy
    });

    const v1 = api.root.addResource('v1');
    const test = v1.addResource('test');

    const signingProfile = new signer.SigningProfile(this, 'SigningProfile', {
      platform: signer.Platform.AWS_LAMBDA_SHA384_ECDSA,
    });

    const codeSigningConfig = new lambdas.CodeSigningConfig(this, 'CodeSigningConfig', {
      signingProfiles: [signingProfile],
    });

    const lambda = new lambdas.Function(this, 'Function', {
      codeSigningConfig,
      runtime: lambdas.Runtime.NODEJS_16_X,
      handler: 'index.handler',
      code: lambdas.Code.fromAsset(join(__dirname, 'lambda-handler')),
    });

    const integration = new apigateway.LambdaIntegration(lambda, {
      proxy: false,
      requestParameters: {},
      allowTestInvoke: true,
      requestTemplates: {},
      passthroughBehavior: apigateway.PassthroughBehavior.NEVER,
      integrationResponses: [],
    });

    test.addMethod('GET', integration, {
      apiKeyRequired: false,
    });
  }
}
