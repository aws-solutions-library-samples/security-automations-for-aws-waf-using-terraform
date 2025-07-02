data "aws_partition" "current" {}

data "aws_region" "current" {}

resource "random_id" "test" {
  byte_length = 8
}

resource "aws_api_gateway_rest_api" "this" {
  name        = var.name
  description = var.description
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_resource" "Resource" {
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "{proxy+}"
  rest_api_id = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_method" "ApiGatewayBadBotMethodRoot" {
  #checkov:skip=CKV2_AWS_53: "Ensure AWS API gateway request is validated"
  #checkov:skip=CKV_AWS_59: "Ensure there is no open access to back-end resources through API"
  authorization      = "NONE"
  http_method        = "ANY"
  api_key_required   = false
  resource_id        = aws_api_gateway_rest_api.this.root_resource_id
  rest_api_id        = aws_api_gateway_rest_api.this.id
  request_parameters = { "method.request.header.X-Forwarded-For" = false }
}

resource "aws_api_gateway_integration" "IntegrationRoot" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_rest_api.this.root_resource_id
  http_method             = aws_api_gateway_method.ApiGatewayBadBotMethodRoot.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.uri
}

#tfsec:ignore:aws-api-gateway-no-public-access
resource "aws_api_gateway_method" "ApiGatewayBadBotMethod" {
  #checkov:skip=CKV2_AWS_53: "Ensure AWS API gateway request is validated"
  #checkov:skip=CKV_AWS_59: "Ensure there is no open access to back-end resources through API"
  authorization      = "NONE"
  http_method        = "ANY"
  api_key_required   = false
  resource_id        = aws_api_gateway_resource.Resource.id
  rest_api_id        = aws_api_gateway_rest_api.this.id
  request_parameters = { "method.request.header.X-Forwarded-For" = false }
}

resource "aws_api_gateway_integration" "Integration" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.Resource.id
  http_method             = aws_api_gateway_method.ApiGatewayBadBotMethod.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.uri
}

resource "aws_api_gateway_deployment" "Deployment" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_api_gateway_method.ApiGatewayBadBotMethod,
    aws_api_gateway_integration.Integration
  ]
}

#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "ApiGatewayBadBotStageAccessLogGroup" {
  #checkov:skip=CKV_AWS_338: "Ensure CloudWatch log groups retains logs for at least 1 year"
  #checkov:skip=CKV_AWS_158: "Ensure that CloudWatch Log Group is encrypted by KMS"
  name              = "api_gateway_badbot_stage_access_log_group_${random_id.test.hex}"
  retention_in_days = 90
}

#tfsec:ignore:aws-api-gateway-enable-tracing
resource "aws_api_gateway_stage" "Stage" {
  #checkov:skip=CKV2_AWS_4: "Ensure API Gateway stage have logging level defined as appropriate"
  #checkov:skip=CKV2_AWS_29: "Ensure public API gateway are protected by WAF"
  #checkov:skip=CKV2_AWS_51: "Ensure AWS API Gateway endpoints uses client certificate authentication"
  #checkov:skip=CKV_AWS_73: "Ensure API Gateway has X-Ray Tracing enabled"
  #checkov:skip=CKV_AWS_76: "Ensure API Gateway has Access Logging enabled"
  #checkov:skip=CKV_AWS_120: "Ensure API Gateway caching is enabled"
  deployment_id = aws_api_gateway_deployment.Deployment.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.api_stage
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.ApiGatewayBadBotStageAccessLogGroup.arn
    format = jsonencode({
      sourceIp       = "$context.identity.sourceIp"
      caller         = "$context.identity.caller"
      user           = "$context.identity.user"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      resourcePath   = "$context.resourcePath"
      protocol       = "$context.protocol"
      status         = "$context.status"
      responseLength = "$context.responseLength"
      requestId      = "$context.requestId"
      }
    )
  }
}


resource "aws_api_gateway_account" "ApiGatewayBadBotAccount" {
  cloudwatch_role_arn = var.cloudwatch_role_arn
}

resource "aws_lambda_permission" "this" {
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = aws_api_gateway_rest_api.this.arn
}