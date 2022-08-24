# Security Groups
data "aws_ssm_parameter" "default_security_group" {
  name = "/cortex-back/${var.stage}/vpc/default_security_group"
}
data "aws_ssm_parameter" "lambda_security_group" {
  name = "/cortex-back/${var.stage}/vpc/lambda_security_group"
}
data "aws_ssm_parameter" "endpoints_security_group" {
  name = "/cortex-back/${var.stage}/vpc/endpoints_security_group"
}

data "aws_ssm_parameter" "log_bucket" {
  name = "/cortex-back/${var.stage}/s3/logs_store"
}

data "http" "jwt" {
  url = "https://cognito-idp.${var.region}.amazonaws.com/${data.aws_ssm_parameter.server_to_server_cognito_pool_id.value}/.well-known/jwks.json"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}

# Subnets
data "aws_ssm_parameter" "subnet_a" {
  name = "/cortex-back/${var.stage}/vpc/subnet_a"
}

data "aws_ssm_parameter" "subnet_b" {
  name = "/cortex-back/${var.stage}/vpc/subnet_b"
}

data "aws_ssm_parameter" "subnet_c" {
  name = "/cortex-back/${var.stage}/vpc/subnet_c"
}

data "aws_ssm_parameter" "public_subnet_a" {
  name = "/cortex-back/${var.stage}/vpc/public_subnet_a"
}

data "aws_ssm_parameter" "public_subnet_b" {
  name = "/cortex-back/${var.stage}/vpc/public_subnet_b"
}

data "aws_ssm_parameter" "public_subnet_c" {
  name = "/cortex-back/${var.stage}/vpc/public_subnet_c"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/shared/${var.stage}/vpc/vpc_id"
}

data "aws_ssm_parameter" "primary_vpc_cidr" {
  name = "/shared/${var.stage}/vpc/primary_vpc_cidr"
}

data "aws_ssm_parameter" "server_to_server_cognito_pool_id" {
  name = "/cortex-back/${var.stage}/server_to_server_cognito/pool_id"
}


data "aws_ssm_parameter" "links_table" {
  name = "/personalize/${var.stage}/dynamodb/content-links"
}

# Account ID
data "aws_caller_identity" "current" {}


data "aws_iam_policy" "AmazonECSTaskExecutionRolePolicy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

module "ecs_tf" {
  stage      = var.stage
  source     = "../ecr"
  name       = var.service
  created_by = var.created_by
  tags       = var.tags
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.service}-${var.stage}"
}

resource "aws_iam_role" "task_and_exec_role" {
  name = "${var.service}-${var.stage}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "my_inline_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["s3:*"]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action   = ["kms:*"]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action   = ["sqs:*"]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action   = ["dynamodb:*"]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action   = ["events:*"]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action   = ["cloudwatch:*"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }

  managed_policy_arns = [data.aws_iam_policy.AmazonECSTaskExecutionRolePolicy.arn]

}

# Security Group For Load Balancer

resource "aws_security_group" "api_task_sg" {
  description = "Allow TLS inbound traffic for ${var.service}"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  egress {
    description      = "Traffic to Anywhere"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.api_load_balancer_sg.id]
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/aws/ecs/${var.service}"
}

resource "aws_ecs_task_definition" "api_task_definition" {
  depends_on = [
    aws_cloudwatch_log_group.log_group
  ]
  family                   = "${var.service}-tf"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.task_and_exec_role.arn
  task_role_arn            = aws_iam_role.task_and_exec_role.arn
  runtime_platform {
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      "name" : "${var.service}-api-server",
      "image" : "${module.ecs_tf.repository_url}:${var.ecs_tf_image_tag}",
      "cpu" : 1024,
      "memory" : 2048,
      "essential" : true,
      "command" : ["api.js"],
      "environment" : [
        { "name" : "ACCOUNT_ID", "value" : "${data.aws_caller_identity.current.account_id}" },
        { "name" : "STAGE", "value" : "${var.stage}" },
        { "name" : "REGION", "value" : "${var.region}" },
        { "name" : "ROLE_ARN", "value" : "${aws_iam_role.task_and_exec_role.arn}" },
        { "name" : "JSON_WEB_KEY", "value" : jsonencode(data.http.jwt.response_body) },
        { "name" : "VIEWS_DB", "value" : "${var.views_db_name}" },
        { "name" : "LINKS_DB", "value" : "${data.aws_ssm_parameter.links_table.value}" }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${aws_cloudwatch_log_group.log_group.name}",
          "awslogs-region" : "${var.region}",
          "awslogs-stream-prefix" : "api"
        }
      },
      "portMappings" : [{
        "protocol" : "tcp"
        "containerPort" : 8080,
        "hostPort" : 8080
      }]
    }
  ])


}

resource "aws_ecs_service" "api_service" {
  name            = "${var.service}-${var.stage}"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.api_task_definition.arn
  launch_type     = "FARGATE"
  desired_count   = (var.stage == "prod") ? 1 : 1

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  network_configuration {
    security_groups = [aws_security_group.api_task_sg.id]
    subnets         = [data.aws_ssm_parameter.subnet_a.value, data.aws_ssm_parameter.subnet_b.value, data.aws_ssm_parameter.subnet_c.value]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api_target_group.arn
    container_name   = "${var.service}-api-server"
    container_port   = 8080
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

}

# Autoscaling Permissions

resource "aws_iam_role" "ecs-autoscale-role" {
  name = "${var.service}-${var.stage}-autoscale"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-autoscale" {
  role       = aws_iam_role.ecs-autoscale-role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}

# Autiscaling Target 

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.api_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  role_arn           = aws_iam_role.ecs-autoscale-role.arn
}

# Autoscaling Metrics

resource "aws_appautoscaling_policy" "ecs_target_cpu" {
  name               = "${var.service}-cpu-scale-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 60
  }
  depends_on = [aws_appautoscaling_target.ecs_target]
}

resource "aws_appautoscaling_policy" "ecs_target_memory" {
  name               = "${var.service}-memory-scale-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 70
  }
  depends_on = [aws_appautoscaling_target.ecs_target]
}

# ECS Target For LB

resource "aws_lb_target_group" "api_target_group" {

  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  health_check {
    enabled = true
    path    = "/health-status"
  }

  depends_on = [
    aws_lb.api_load_balancer
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# LB Listener

resource "aws_alb_listener" "tls_listener" {
  load_balancer_arn = aws_lb.api_load_balancer.id
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn = aws_acm_certificate.load_balancer_cert.arn

  depends_on = [
    aws_acm_certificate.load_balancer_cert,
    aws_acm_certificate_validation.load_balancer_cert
  ]

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      message_body = "{\"message\":\"Forbidden\"}"
      status_code  = "403"
    }

  }
}

resource "aws_lb_listener_rule" "public" {
  listener_arn = aws_alb_listener.tls_listener.arn
  priority     = 100

  action {
    target_group_arn = aws_lb_target_group.api_target_group.id
    type             = "forward"
  }

  condition {
    path_pattern {
      values = ["/v1/*"]
    }
  }
}

# resource "aws_lb_listener_rule" "internal" {
#   listener_arn = aws_alb_listener.tls_listener.arn
#   priority     = 150

#   action {
#     target_group_arn = aws_lb_target_group.api_target_group.id
#     type             = "forward"
#   }

#   condition {
#     path_pattern {
#       values = ["/internal/*"]
#     }
#   }
# }


resource "aws_lb_listener_rule" "external_aem" {
  listener_arn = aws_alb_listener.tls_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_target_group.id
  }


  condition {
    path_pattern {
      values = ["/external/aem/*"]
    }
  }
}

# Security Group For Load Balancer

resource "aws_security_group" "api_load_balancer_sg" {
  description = "Allow TLS inbound traffic for ${var.service}"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  ingress {
    description      = "TLS from Anywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_ssm_parameter.primary_vpc_cidr.value]
  }
}

# Load Balancer

resource "aws_lb" "api_load_balancer" {
  name               = "${var.service}-api-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [data.aws_ssm_parameter.public_subnet_a.value, data.aws_ssm_parameter.public_subnet_b.value, data.aws_ssm_parameter.public_subnet_c.value]
  security_groups    = [aws_security_group.api_load_balancer_sg.id]
  ip_address_type    = "ipv4"

  enable_deletion_protection       = true
  enable_cross_zone_load_balancing = true

  access_logs {
    bucket  = data.aws_ssm_parameter.log_bucket.value
    prefix  = "o-tm93a0g491"
    enabled = true
  }

  tags = var.tags
}

# Certificates

resource "aws_acm_certificate" "load_balancer_cert" {
  domain_name       = var.stage == "prod" ? "api.ecs-tf.${var.region}.sls.global" : "api.ecs-tf.${var.region}.${var.stage}.sls.global"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}


data "aws_route53_zone" "load_balancer_cert" {
  name         = "${var.stage}.sls.global"
  private_zone = false
}


resource "aws_route53_record" "load_balancer_cert" {
  for_each = {
    for dvo in aws_acm_certificate.load_balancer_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.load_balancer_cert.zone_id
}

resource "aws_acm_certificate_validation" "load_balancer_cert" {
  certificate_arn         = aws_acm_certificate.load_balancer_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.load_balancer_cert : record.fqdn]
}

resource "aws_route53_record" "api_record" {
  zone_id = data.aws_route53_zone.load_balancer_cert.zone_id
  name    = var.stage == "prod" ? "api.ecs-tf.${var.region}.sls.global" : "api.ecs-tf.${var.region}.${var.stage}.sls.global"
  type    = "A"
  alias {
    name                   = aws_lb.api_load_balancer.dns_name
    zone_id                = aws_lb.api_load_balancer.zone_id
    evaluate_target_health = true
  }
}
