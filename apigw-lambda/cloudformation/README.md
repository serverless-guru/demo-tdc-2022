# apigw-lambda Cloudformation

## Inititalize
If you don't already have one, create a deployment bucket to upload your zipped lambdas

## Deploy
```bash
export AWS_PROFILE=myProfile
export AWS_REGION=eu-central-1
TLD=example.com
projectName=myapi
deployBucket=myBucket
./deploy.sh
```
## Notes
### Cons
- Each path parts needs to be defined individually
- A lot of defintions needed
- New deployments need a new Cloudformation object
- Each function is hardcoded: this could be reduced by using stackSets
- A Framework like serverless.com makes the above steps easier
### Pros
- Same region ACM DNS validation is easy