# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  environment = "dev"
  vpc_cidr     = "172.18.0.0/16"
  vpc_id      = "vpc-xyz"
  private_subnet_ids      = ["subnet-pr1,subnet-pr2"]
  public_subnet_ids      = ["subnet-pu1,subnet-pu2"]
}