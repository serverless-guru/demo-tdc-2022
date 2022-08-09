# Welcome to your CDK TypeScript project

You should explore the contents of this project. It demonstrates a CDK app with an instance of a stack (`CdkWorkshopStack`)
which contains an Amazon SQS queue that is subscribed to an Amazon SNS topic.

The `cdk.json` file tells the CDK Toolkit how to execute your app.

## Useful commands

* `npm run build`   compile typescript to js
* `npm run watch`   watch for changes and compile
* `npm run test`    perform the jest unit tests
* `cdk deploy`      deploy this stack to your default AWS account/region
* `cdk diff`        compare deployed stack with current state
* `cdk synth`       emits the synthesized CloudFormation template

## Notes
### Pros
* can use real `if`, `loops`, string manipulation, variables
* Cross region made easy with the `region` parameter
* Typed, Automatic autofill/validation with Typescript types
* `diff`, `synth`, `watch`, `--hotswap`
### Cons
* Like aws-sdk, the dual versions `aws-cdk-lib` and `@aws-cdk` makes it very difficult for a beginner