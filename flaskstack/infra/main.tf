module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.24.2"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  create_kms_key = false

  cluster_endpoint_public_access          = true
  cluster_endpoint_private_access         = true
  cluster_endpoint_public_access_cidrs    = ["0.0.0.0/0"] # מומלץ להגביל ל-IP שלך

  cluster_encryption_config = {
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }

  eks_managed_node_groups = {
    default = {
      min_size       = 1
      max_size       = 3
      desired_size   = var.node_count
      instance_types = ["t3.medium"]
    }
  }

  map_users = [
    {
      userarn  = "arn:aws:iam::557690607676:user/flaskstack"
      username = "flaskstack"
      groups   = ["system:masters"]
    }
  ]

  tags = {
    "Environment" = var.environment
  }
}
