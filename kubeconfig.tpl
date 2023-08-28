apiVersion: v1
kind: Config
preferences: {}
clusters:
- cluster:
    server: ${endpoint}
    certificate-authority-data: ${cluster_auth_base64}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "eks-cluster"