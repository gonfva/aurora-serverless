resource "aws_lambda_function" "db_user_creation" {
  filename      = data.archive_file.function_zip.output_path
  function_name = "db_user_creation-${var.slug}"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda.handler"
  runtime       = "python3.12"
  timeout       = 300

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      DB_HOST           = var.db_endpoint
      DB_NAME           = var.db_name
      DB_ADMIN_USER     = var.db_users["admin"]
      DB_ADMIN_PASSWORD = var.db_passwords["admin"]
      DB_PORT           = var.port
    }
  }
}

resource "aws_security_group" "lambda_sg" {
  name        = "lambda-${var.slug}"
  description = "Security group associated with the lambda function db_user_creation-${var.slug}"
  vpc_id      = var.vpc_id

  tags = var.tags
}

resource "aws_security_group_rule" "db_in_lambda_sg" {
  type                     = "ingress"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  security_group_id        = var.db_sg
  source_security_group_id = aws_security_group.lambda_sg.id
}

resource "aws_security_group_rule" "db_lambda_sg" {
  type                     = "egress"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.lambda_sg.id
  source_security_group_id = var.db_sg
}
