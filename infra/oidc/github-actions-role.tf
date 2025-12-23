resource "aws_iam_role" "github_actions" {
  name = "github-actions-terraform"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              "repo:oanyabwile/terraform-enterprise-pipeline:ref:refs/heads/main",
              "repo:oanyabwile/terraform-enterprise-pipeline:environment:prod",
              "repo:oanyabwile/terraform-aws-core-infra:ref:refs/heads/main"

            ]
          }
        }
      }
    ]
  })
}
