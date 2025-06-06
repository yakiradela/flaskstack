module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "5.0.0"
  name                   = "vpc"
  cidr                   = "10.0.0.0/16"
  azs                    = ["us-east-2a", "us-east-2b"]
  public_subnets         = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets        = ["10.0.3.0/24", "10.0.4.0/24"]
  enable_nat_gateway     = true
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.24.2"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  enable_cluster_encryption = true

  cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }]

  eks_managed_node_groups = {
    default = {
      min_size       = 1
      max_size       = 3
      desired_size   = var.node_count
      instance_types = ["t3.medium"]
    }
  }
}


