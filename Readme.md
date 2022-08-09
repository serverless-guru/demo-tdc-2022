# Generic notes on the tools used

### Terraform
- Deploys what it can, skips the failed resources
- Each `apply` puts the stack in the state defined in Terraform
- Modular stacks via 
- Supports basic `if`, `for`
- Can define and re-use variables inside a template
- Ability to preview changes (`terraform plan`)

### Cloudformation
- Deploys everything or nothing
- Changes done outside Cloudformation aren't reversed on stack update
- Modular stack via StackSets
- Cross Region via StackSets
- No support for loops
- Supports conditions
- no in template variables, only external parameters

### CDK
- Ability to preview changes (`cdk diff`)
- Quick deploy for Lambda functions (`cdk deploy --hotswap`)
- Retrieve info on existing unmanaged resources
- Easy cross region
- `aws-cdk-lib` vs `@aws-cdk` is confusing