# Creates new user
resource "aws_iam_user" "admin-user" {
    name = "Deja2" 
}

# Admin user access policy
resource "aws_iam_policy" "for-admin-users" {
  name = "AdminUsers"
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "iam:GetUser",
      "Resource": "*"
    }
  ]
})
}

# Attaches IAM Policy to user Deja2
resource "aws_iam_user_policy_attachment" "Deja2-admin-acess" {
  user = aws_iam_user.admin-user.name
  policy_arn = aws_iam_policy.for-admin-users.arn
}

# Roles
# Creates new role
resource "aws_iam_role" "for_lambda" {
  name               = "for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Policy for role access to cloudwatch
resource "aws_iam_policy" "cloudwatch-policy" {
  name        = "policy-for-cloudwatch"
  description = "Policy for cloudwatch"
  policy      = data.aws_iam_policy_document.policy.json
}

# Creates IAM policy document in JSON format for access to cloudwatch
data "aws_iam_policy_document" "policy" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream",
                "logs:PutLogEvents"]
    resources = ["*"]
  }
}

# Attaches IAM Policy to role for_lambda
resource "aws_iam_role_policy_attachment" "for-lambda-cloudwatch-acess" {
  role       = aws_iam_role.for_lambda.name
  policy_arn = aws_iam_policy.cloudwatch-policy.arn
}

# Creates IAM policy document in JSON format
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"


    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "events.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
    
  }
}