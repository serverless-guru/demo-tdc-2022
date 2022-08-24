locals {
  name = "ecs-tf-${var.stage}-${var.name}"
  tags = merge(var.tags,
    {
      Name = local.name
  })
}

resource "aws_iam_user" "iam_user" {
  name = local.name
  tags = local.tags
}
