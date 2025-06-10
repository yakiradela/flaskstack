module "aws_auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "20.24.2"

  cluster_name = module.eks.cluster_name
  create       = true

  manage_aws_auth_configmap = true

  map_users = [
    {
      userarn  = "arn:aws:iam::557690607676:user/flaskstack"
      username = "flaskstack"
      groups   = ["system:masters"]
    }
  ]
}


