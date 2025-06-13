resource "aws_ecr_repository" "flaskstack" {
  name                 = "flaskstack-ecr"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

