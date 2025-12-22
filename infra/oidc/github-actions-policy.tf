resource "aws_iam_policy" "terraform_pipeline" {
  name        = "terraform-pipeline-policy"
  description = "Permissions for Terraform CI/CD pipeline via GitHub Actions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:*",
          "s3:*",
          "dynamodb:*",
          "ec2:*",
          "elasticloadbalancing:*",
          "autoscaling:*",
          "rds:*",
          "logs:*",
          "cloudwatch:*",
          "ssm:*",
          "kms:*"
        ]
        Resource = "*"
      }
    ]
  })
}
