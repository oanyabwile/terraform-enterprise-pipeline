resource "aws_iam_role_policy_attachment" "terraform_pipeline_attach" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.terraform_pipeline.arn
}
