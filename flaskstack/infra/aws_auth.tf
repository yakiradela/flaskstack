module "aws_auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "20.24.2"

  create                        = true
  manage_aws_auth_configmap     = true

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::557690607676:user/flaskstack"
      username = "flaskstack"
      groups   = ["system:masters"]
    }
  ]

  aws_auth_roles = [
    {
      rolearn  = module.eks.eks_managed_node_groups["default"].iam_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    }
  ]
}

