##
# The configuration for this backend will be filled in by Terragrunt
#
# https://terragrunt.gruntwork.io/docs/features/keep-your-remote-state-configuration-dry/
#
terraform {
  backend "s3" {}
}

#
# EC2
#
# https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest
#
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "${local.name}_ec2_${var.deployment_id}"

  ami                    = "ami-ebd02392"
  instance_type          = "t2.micro"
  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = "subnet-eddcdzz4"

  tags = {
    Name = "${local.name}-${var.deployment_id}",
    Owner   = basename(data.aws_caller_identity.current.arn),
    Project = local.name,
  }
}