resource "random_id" "kms_alias_suffix" {
  byte_length = 4
}

resource "aws_kms_key" "eks" {
  description             = "KMS key for Flaskstack"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_kms_alias" "eks" {
  name          = "alias/Flaskstack-${var.environment}-${random_id.kms_alias_suffix.hex}"
  target_key_id = aws_kms_key.eks.key_id
}
