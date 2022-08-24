# S3 with Firehose Module

Example Usage

```
module "s3_with_firehose" {
  source     = "./modules/s3"
  stage      = "dev"
  name       = "mydata"
  created_by = "John Smith"
}

```

## Notes

The local name variable does not contain any underscores because of aws resource naming restrictions
