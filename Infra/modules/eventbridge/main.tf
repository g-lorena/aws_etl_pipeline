resource "aws_cloudwatch_event_rule" "schedule" {
    name = var.schedule_name #"schedule"
    description = "Schedule for Lambda Function"
    schedule_expression = var.schedule_value
}

resource "aws_cloudwatch_event_target" "schedule_lambda" {
    rule = aws_cloudwatch_event_rule.schedule.name
    target_id = "processing_lambda"
    arn = var.aws_lambda_arn
}

resource "aws_lambda_permission" "allow_events_bridge_to_run_lambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = var.aws_lambda_function_name
    principal = "events.amazonaws.com"
}