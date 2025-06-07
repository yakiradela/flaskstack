resource "null_resource" "aws_auth" {
  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}
      kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapUsers: |
    - userarn: arn:aws:iam::557690607676:user/flaskstack
      username: flaskstack
      groups:
        - system:masters
EOF
    EOT
  }
}

