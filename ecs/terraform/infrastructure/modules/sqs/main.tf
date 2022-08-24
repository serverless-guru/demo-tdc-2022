data "aws_caller_identity" "current" {}
locals {
  redrive_policy = (var.deadLetterTargetArn != "" ? jsonencode({
    deadLetterTargetArn = var.deadLetterTargetArn
    maxReceiveCount     = var.maxReceiveCount
  }) : null)
  tags = merge(var.tags,
    {
      Name = var.name
  })
}

resource "aws_sqs_queue" "queue" {
  name                       = "${var.name}-${var.stage}"
  delay_seconds              = 0
  receive_wait_time_seconds  = 0
  redrive_policy             = local.redrive_policy
  visibility_timeout_seconds = var.visibilityTimeout

  kms_master_key_id = var.kms_master_key_id != "" ? var.kms_master_key_id : null

  tags = local.tags
}
