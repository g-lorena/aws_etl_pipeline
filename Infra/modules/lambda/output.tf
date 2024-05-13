output "lambda_function_name" {
  value = aws_lambda_function.lambda.function_name
  description = "lambda function name"
}

output "lambda_function_arn" {
  value = aws_lambda_function.lambda.arn
  description = "arn of the lambda function"
}