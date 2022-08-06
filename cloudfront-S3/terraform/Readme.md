# Static website hosting with S3, Cloudfront and SSL

* Creates an S3 bucket (with website enabled) in a region of your choice using your domain as name.
* Creates an SSL certificate with ACM in us-east-1 for your site domain.
* Creates a Cloudfront distribution with your site domain as alias, using the above certificate.

## Deploy
```
cp terraform.tfvars.sample terraform.tfvars
```

Edit `terraform.tfvars` to suite your needs

```
terraform init
terraform deploy
```