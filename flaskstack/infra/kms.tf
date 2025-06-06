resource "aws_kms_key" "eks" {
  description = "KMS for EKS cluster encryption"
  enable_key_rotation = true
}

resource "aws_kms_alias" "eks" {
  name          = "alias/Flaskstack-kms123"
  target_key_id = aws_kms_key.eks.key_id
}
