locals {
  internal_destination_account_id         = data.aws_caller_identity.current.account_id
  internal_destination_account_arn        = "arn:aws:iam::${local.internal_destination_account_id}:root"
  internal_destination_account_admin_role = "arn:aws:iam::${local.internal_destination_account_id}:role/AWS_MARTECH_${upper(var.stage)}_ADMINS"
  tags = merge(var.tags,
    {
      UsedFor = var.used_for
  })
}

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "key" {
  description             = "This key is used to encrypt Cortex internal data"
  deletion_window_in_days = 30
  policy                  = data.aws_iam_policy_document.kms_access_policy.json
  tags                    = local.tags
  enable_key_rotation     = true
}

# Policy to allow remote account to use internal KMS key. Keeping internal account as administrator
data "aws_iam_policy_document" "kms_access_policy" {
  statement {
    sid    = "allow administrator of the key"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        local.internal_destination_account_arn
      ]
    }
    actions = [
      "kms:*"
    ]
    resources = [
      "*"
    ]
  }

  # --------------------------------
  # Grant access to admin role
  # From https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html
  # --------------------------------
  statement {
    sid    = "Allow admin role"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        local.internal_destination_account_admin_role
      ]
    }
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = [
      "*"
    ]
  }

  # --------------------------------
  # Grant access to services
  # From https://aws.amazon.com/blogs/compute/encrypting-messages-published-to-amazon-sns-with-aws-kms/
  # For Amazon CloudWatch alarms, use cloudwatch.amazonaws.com
  # For Amazon CloudWatch events, use events.amazonaws.com
  # For Amazon DynamoDB events, use dynamodb.amazonaws.com
  # For Amazon Glacier events, use glacier.amazonaws.com
  # For Amazon Redshift events, use redshift.amazonaws.com
  # For Amazon Simple Email Service events, use ses.amazonaws.com
  # For Amazon Simple Storage Service events, use s3.amazonaws.com
  # For AWS CodeCommit events, use codecommit.amazonaws.com
  # For AWS Database Migration Service events, use dms.amazonaws.com
  # For AWS Directory Service events, use ds.amazonaws.com
  # For AWS Snowball events, use importexport.amazonaws.com
  # --------------------------------
  statement {
    sid    = "Allow AWS Services"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "cloudwatch.amazonaws.com",
        "events.amazonaws.com",
        "dynamodb.amazonaws.com",
        "s3.amazonaws.com",
        "sns.amazonaws.com",
        "kinesis.amazonaws.com",
        "firehose.amazonaws.com"
      ]
    }
    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_kms_alias" "alias" {
  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.key.key_id
}
