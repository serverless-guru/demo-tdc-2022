import type { Construct } from 'constructs';

import { Stack, StackProps } from 'aws-cdk-lib';

import * as ec2 from 'aws-cdk-lib/aws-ec2';


export class NetworkStack extends Stack {

  public vpc: ec2.Vpc;

  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const vpc = new ec2.Vpc(this, 'TheVPC', {
      cidr: '10.0.0.0/16',
      vpcName: 'ecs-cdk-app-vpc',
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

    this.vpc = vpc;
  }
}
