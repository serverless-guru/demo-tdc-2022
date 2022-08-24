# SQS Module

Example Usage:

```tf
module "sqs" {
    source     = "./modules/sqs"
    name       = "reservations"
    created_by = "John Smith"
    stage      = "dev"
    region     = "us-east-2"
}
```
