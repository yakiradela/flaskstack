variable "aws_region" {
    default = "us-east-1"
}

variable "cluster_name" {
    default = "eks-cluster"  
}

variable "node_count" {
    default = 2 
}

variable "environment" {
  description = "The deployment environment name (e.g. dev, staging, prod)"
  type        = string
  default     = "dev" 
}
