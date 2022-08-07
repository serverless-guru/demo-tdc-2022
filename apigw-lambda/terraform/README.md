# apigw-lambda terraform

## Inititalize

- Replace `tushar-sharma-slsguru-tdc-demo-terraform-backend` with your terraform backend bucket name.
- Replace `ap-south-1` with your region.
- Replace `apigw-lambda-tf-app` with your service name.
- Replace `Tushar` with your local cli admin user name. This user should already exist in the IAM users.

One time steps.

```shell
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

## Notes

- The path part is annoying. This is where frameworks like serverless framework shines. I don't have
  to deal with connecting parent path to child path multiple times to create a /a/b/c/d api.
- Lots of freedom in terms of deploying infrastructure components.
- Lots of freedom in passing values around different resources.
- I get all the terraform utility function support.