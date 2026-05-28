resource "aws_iam_user" "bedrock_dev_view" {
  name = "bedrock-dev-view"
}

resource "aws_iam_user_login_profile" "bedrock_dev_view" {
  user                    = aws_iam_user.bedrock_dev_view.name
  password_reset_required = true
  password_length         = 20
}

resource "aws_iam_access_key" "bedrock_dev_view" {
  user = aws_iam_user.bedrock_dev_view.name
}

resource "aws_iam_user_policy_attachment" "bedrock_dev_view_read_only" {
  user       = aws_iam_user.bedrock_dev_view.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_user_policy" "bedrock_dev_view_s3_put" {
  name = "bedrock-dev-view-s3-put"
  user = aws_iam_user.bedrock_dev_view.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::${var.assets_bucket_name}/*"
      }
    ]
  })
}

resource "aws_eks_access_entry" "bedrock_dev_view" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_user.bedrock_dev_view.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "bedrock_dev_view" {
  cluster_name  = module.eks.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
  principal_arn = aws_iam_user.bedrock_dev_view.arn

  access_scope {
    type       = "namespace"
    namespaces = ["retail-app"]
  }
}
