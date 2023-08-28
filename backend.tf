terraform {
  backend "s3" {
    bucket         = "tf-backend-eks-cluster"
    key            = "terraform-aws-eks-evonem.tfstate"
    region         = "eu-central-1"
  }
}
