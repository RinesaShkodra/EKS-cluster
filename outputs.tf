locals {
  kubeconfig = templatefile("kubeconfig.tpl", {
    endpoint                          = aws_eks_cluster.this.endpoint
    cluster_auth_base64               = aws_eks_cluster.this.certificate_authority[0].data
    aws_authenticator_command         = "aws-iam-authenticator"
    aws_authenticator_additional_args = []
    aws_authenticator_env_variables   = {}
  })
}

output "kubeconfig" { value = local.kubeconfig }