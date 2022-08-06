# Cross Account / Cross Region Roles
This roles are needed to be able to deploy cross accounts and cross regions stack sets.

Source: [AWS - Grant self-managed permissions](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-prereqs-self-managed.html).

This roles needs to be deployed only once per account. deploy the following stacks only if you haven't already done so.

## Master account

Deploy [AWSCloudFormationStackSetAdministrationRole](AWSCloudFormationStackSetAdministrationRole.yml)
```bash
export AWS_PROFILE=master-account
aws cloudformation create-stack \
  --stack-name StackSetAdmin \
  --template-body file://AWSCloudFormationStackSetAdministrationRole.yml \
  --capabilities CAPABILITY_NAMED_IAM
AWSAccountId=$(aws sts get-caller-identity --query "Account" --output text)

```

## Slave accounts
This needs to be created even if the master and slave accounts are the same.

Deploy [AWSCloudFormationStackSetExecutionRole](AWSCloudFormationStackSetExecutionRole.yml) in each slave accounts.
```bash
export AWS_PROFILE=master-account
AWSAccountId=$(aws sts get-caller-identity --query "Account" --output text)
export AWS_PROFILE=slave-account
aws cloudformation create-stack \
  --stack-name StackSetExecution \
  --template-body file://AWSCloudFormationStackSetExecutionRole.yml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters ParameterKey=AdministratorAccountId,ParameterValue=$AWSAccountId
```
