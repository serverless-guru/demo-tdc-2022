# ecs cdk

## Inititalize

- Replace `tushar-sharma-slsguru-tdc-demo-terraform-backend` with your terraform backend bucket name.
- Replace `ap-south-1` with your region.
- Replace `ecs-tf-app` with your service name.
- Replace `Tushar` with your local cli admin user name. This user should already exist in the IAM users.

One time steps.

```shell
npm install -g cdk
chmod +x terraform-setup.sh
chmod +x deploy.sh
chmod +x destroy.sh
./terraform-setup.sh
terraform init
```

Every time you need to deploy. You need to run the following.

```shell
./deploy.sh
```

The `cdk.json` file tells the CDK Toolkit how to execute your app.

## Useful commands

- `npm run build` compile typescript to js
- `npm run watch` watch for changes and compile
- `npm run test` perform the jest unit tests
- `cdk deploy` deploy this stack to your default AWS account/region
- `cdk diff` compare deployed stack with current state
- `cdk synth` emits the synthesized CloudFormation template

## Notes

- Errors are sometimes not clear. I couldn't use my own vpc availability zones.
