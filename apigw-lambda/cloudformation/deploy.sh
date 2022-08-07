#!/bin/bash

yarn build

cd dist
zip -r hello-world.zip *
cd ..

hostedZoneId=$(aws route53 list-hosted-zones-by-name \
--dns-name $TLD \
--query "HostedZones[0].Id" \
--output text | \
cut -d/ -f3)
projectName=$projectName TLD=$TLD hostedZoneId=$hostedZoneId deployBucket=$deployBucket envsubst < infrastructure/parameters.template.json  > infrastructure/parameters.json

aws s3 cp dist/hello-world.zip s3://$deployBucket/$projectName/hello-world.zip

aws cloudformation create-stack \
  --stack-name $projectName \
  --template-body file://infrastructure/template.yml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters file://infrastructure/parameters.json
```

rm -rf dist/