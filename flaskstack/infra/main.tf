module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name                 = "flaskstack-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = ["${var.aws_region}a", "${var.aws_region}b"]
  public_subnets       = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets      = ["10.0.3.0/24", "10.0.4.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

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
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.2"

  cluster_name    = var.cluster_name
  cluster_version = "1.32"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  create_kms_key                        = false
  cluster_encryption_config             = []
  cluster_endpoint_public_access        = true
  cluster_endpoint_private_access       = true
  cluster_endpoint_public_access_cidrs  = ["0.0.0.0/0"]
  authentication_mode                   = "API"

  eks_managed_node_groups = {
    default = {
      min_size       = 1
      max_size       = 3
      desired_size   = var.node_count
      instance_types = ["t3.medium"]
    }
  }

  tags = {
    "Environment" = var.environment
  }
}

resource "aws_eks_access_entry" "github_actions_user" {
  cluster_name      = module.eks.cluster_name
  principal_arn     = "arn:aws:iam::${var.aws_account_id}:user/flaskstack"
  kubernetes_groups = ["admin"] # שים לב! לא system:masters
  type              = "STANDARD"
}

