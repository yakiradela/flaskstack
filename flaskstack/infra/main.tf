module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "5.0.0"
  name                   = "flaskstack-vpc"
  cidr                   = "10.0.0.0/16"
  azs                    = ["${var.aws_region}a", "${var.aws_region}b"]
  public_subnets         = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets        = ["10.0.3.0/24", "10.0.4.0/24"]
  enable_nat_gateway     = true
  single_nat_gateway     = true
  enable_dns_hostnames   = true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "Environment"                               = var.environment
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.24.2"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  create_kms_key = false

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

  # כאן הוספתי את הגדרת הגישה ל-API:
  access_config = {
    endpoint_public_access  = true
    endpoint_private_access = true
    public_access_cidrs     = ["0.0.0.0/0"]  # אפשר להגביל לטווח IP שלך במקום 0.0.0.0/0
  }

  tags = {
    "Environment" = var.environment
  }
}

