data "aws_iam_policy_document" "glue_assume_role" {
  statement {
  
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_glue" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "glue_policy_document" {
  statement {
      effect    = "Allow"
      actions   = [
        "s3:GetBucketLocation",
        "s3:ListBucket",
        "s3:GetBucketAcl",
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
        ]
      resources = ["*"] #to be specify later
    }
  statement {
      effect    = "Allow"
      actions   = [
        "glue:*"
        ]
      resources = ["*"] 
    }
  statement {
      effect    = "Allow"
      actions   = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
        ]
      resources = [
        "arn:aws:logs:*:*:*:/aws-glue/*"
        ] #to be specify later
    }
}

resource "aws_iam_policy" "glue_policy" {
  name        = "glue-policy"
  description = "allow lambda to get and list object into the bucket"
  policy      = data.aws_iam_policy_document.glue_policy_document.json
}

resource "aws_iam_role_policy_attachment" "attach_getObject" {
  role       = aws_iam_role.iam_for_glue.name
  policy_arn = aws_iam_policy.glue_policy.arn
}