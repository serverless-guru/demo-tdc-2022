

import type { Construct } from 'constructs';

import { Stack, StackProps } from 'aws-cdk-lib';

import * as ec2 from 'aws-cdk-lib/aws-ec2';
import * as ecs from 'aws-cdk-lib/aws-ecs';
import * as iam from 'aws-cdk-lib/aws-iam';


interface EcsProps extends StackProps {
  vpc: ec2.Vpc
}

export class EcsService extends Stack {
  constructor(scope: Construct, id: string, props: EcsProps) {
    super(scope, id, props);

    // Create an ECS cluster
    const cluster = new ecs.Cluster(this, 'Cluster', {
      vpc: props.vpc,
      clusterName: id,
    });


    // the role assumed by the task and its containers
    const taskRole = new iam.Role(this, "task-role", {
      assumedBy: new iam.ServicePrincipal("ecs-tasks.amazonaws.com"),
      roleName: "task-role",
      description: "Role that the api task definitions use to run the api code",
    });

    taskRole.attachInlinePolicy(
      new iam.Policy(this, "task-policy", {
        statements: [
          // policies to allow access to other AWS services from within the container e.g SES (Simple Email Service)
          new iam.PolicyStatement({
            effect: iam.Effect.ALLOW,
            actions: ["SES:*"],
            resources: ["*"],
          }),
        ],
      })
    );


    // the role assumed by the task and its containers
    const ecsRole = new iam.Role(this, "ecs-exec-role", {
      assumedBy: new iam.ServicePrincipal("ecs-tasks.amazonaws.com"),
      roleName: "ecs-role",
      description: "Role that the api task definitions use to run the api code",
    });

    ecsRole.addManagedPolicy(
      iam.ManagedPolicy.fromManagedPolicyArn(
        this,
        "ecs-exec-role-managed",
        "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
      )
    );

    const taskDefinition = new ecs.FargateTaskDefinition(this, 'TaskDef', {
      family: "task",
      taskRole: taskRole,
      executionRole: ecsRole,
    });

    // The docker container including the image to use
    const container = taskDefinition.addContainer("container", {
      image: ecs.RepositoryImage.fromRegistry("public.ecr.aws/nginx/nginx:latest"),
      memoryLimitMiB: 512,
      portMappings: [{
        containerPort: 80,
      }],
      environment: {
        "NGINX_PORT": "80"
      },
      // store the logs in cloudwatch 
      logging: ecs.LogDriver.awsLogs({ streamPrefix: "example-api-logs" }),
    });

    const sg = new ec2.SecurityGroup(this, "ServiceSG", {
      securityGroupName: "ecs-group",
      vpc: props.vpc,
      allowAllOutbound: true,
    })

    sg.addIngressRule(ec2.Peer.anyIpv4(), new ec2.Port(
      {
        protocol: ec2.Protocol.TCP,
        toPort: 80,
        fromPort: 80,
        stringRepresentation: "stringRepresentation"
      }
    ), "allow all", false)

    const ecsService = new ecs.FargateService(this, 'Service', {
      vpcSubnets: {
        subnets: props.vpc.publicSubnets,
      },
      securityGroups: [sg],
      assignPublicIp: true,
      enableExecuteCommand: true,
      maxHealthyPercent: 200,
      minHealthyPercent: 100,
      serviceName: id,
      desiredCount: 1,
      cluster,
      taskDefinition,
    });

  }
}
