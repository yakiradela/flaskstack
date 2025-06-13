variable "aws_region" {
  description = "The AWS region to deploy in"
  type        = string
  default     = "us-east-2"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "Flaskstack-cluster"
}

variable "node_count" {
  description = "Desired number of nodes in the EKS cluster"
  type        = number
  default     = 2
}

variable "environment" {
  description = "The deployment environment (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "ecr_repository_name" {
  description = "The name of the ECR repository"
  type        = string
  default     = "flaskstack-ecr"
}
