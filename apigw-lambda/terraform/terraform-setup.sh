BUCKET_NAME=tushar-sharma-slsguru-tdc-demo-terraform-backend
BUCKET_REGION=ap-south-1
USER_NAME=Tushar
POLICY_FILE_NAME=$PWD/policy.json

aws s3api create-bucket \
    --bucket $BUCKET_NAME \
    --region $BUCKET_REGION \
    --create-bucket-configuration \
    LocationConstraint=$BUCKET_REGION 1> /dev/null

echo "Bucket has been created"

aws s3api put-bucket-encryption \
    --bucket $BUCKET_NAME \
    --server-side-encryption-configuration={\"Rules\":[{\"ApplyServerSideEncryptionByDefault\":{\"SSEAlgorithm\":\"AES256\"}}]} 1> /dev/null

echo "Bucket encryption has been set"

USER_ARN=$(aws iam get-user --user-name $USER_NAME --output text --query 'User.Arn')

echo "User details have been fetched"

sleep 5

aws iam attach-user-policy \
    --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess \
    --user-name $USER_NAME 1> /dev/null

aws iam attach-user-policy \
    --policy-arn arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess \
    --user-name $USER_NAME 1> /dev/null

echo "User policies has been attached"

cat <<-EOF >> $POLICY_FILE_NAME
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AlloTerraformUser",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${USER_ARN}"
      },
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::${BUCKET_NAME}/*"
    }
  ]
}
EOF

aws s3api put-bucket-policy \
    --bucket $BUCKET_NAME \
    --policy file://$POLICY_FILE_NAME 1> /dev/null

echo "Bucket policy has been set"
rm $POLICY_FILE_NAME

aws s3api put-bucket-versioning \
    --bucket $BUCKET_NAME \
    --versioning-configuration Status=Enabled 1> /dev/null

echo "Bucket versioning has been set"

aws dynamodb create-table \
    --table-name "$BUCKET_NAME-lock" \
    --attribute-definitions \
        AttributeName=LockID,AttributeType=S \
    --key-schema \
        AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput \
        ReadCapacityUnits=20,WriteCapacityUnits=20 \
    --table-class STANDARD 1> /dev/null

echo "Dynamo DB has been created"