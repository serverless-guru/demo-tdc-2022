# Account ID
data "aws_caller_identity" "current" {}

# define a zip archive
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/tmp/${var.func_name}.zip"
  source {
    content  = file("${path.module}/../../../dist/${var.func_name}.js")
    filename = "index.js"
  }

  source {
    content  = fileexists("${path.module}/../../../dist/vendor.js") ? file("${path.module}/../../../dist/vendor.js") : ""
    filename = "vendor.js"
  }

}

resource "aws_iam_role" "iam_for_lambda" {
  name = "lambda-${local.name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${local.name}"
  retention_in_days = 14
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda-${local.name}"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
     {
        "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:logs:*:*:*"
    },
    {
        "Action": [
            "ec2:DescribeNetworkInterfaces",
            "ec2:CreateNetworkInterface",
            "ec2:DeleteNetworkInterface",
            "ec2:DescribeInstances",
            "ec2:AttachNetworkInterface"
        ],
        "Effect": "Allow",
        "Resource": "*"
    },
    {
        "Action": [
            "dynamodb:PutItem",
            "dynamodb:GetItem"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:dynamodb:ap-south-1:${data.aws_caller_identity.current.account_id}:table/*"
    },
    {
        "Action": [
            "kms:Decrypt",
            "kms:GenerateDataKey"
        ],
        "Effect": "Allow",
        "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}


# Security Group For Lambda

resource "aws_security_group" "lambda_sg" {
  description = "Allow TLS inbound traffic for ${var.service}"
  vpc_id      = var.vpc_id

  egress {
    description      = "Traffic to Anywhere"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_lambda_function" "lambda" {
  # If the file is not in the current working directory you will need to include a 
  # path.module in the filename.
  filename      = "${path.module}/tmp/${var.func_name}.zip"
  function_name = local.name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  runtime = "nodejs14.x"

  environment {
    variables = {
      ACCOUNT_ID = "${data.aws_caller_identity.current.account_id}"
      REGION     = "${var.region}"
    }
  }
}
