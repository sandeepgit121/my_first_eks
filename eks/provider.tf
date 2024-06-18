locals {
  region = "ap-south-1"
  name   = "amonkincloud-cluster"
  vpc_cidr = "10.10.0.0/16"
  azs      = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnets = ["10.10.3.0/24", "10.10.4.0/24"]
  intra_subnets   = ["10.10.5.0/24", "10.10.6.0/24"]
  tags = {
    Example = local.name
  }
}

provider "aws" {
  region = "ap-south-1"
}
