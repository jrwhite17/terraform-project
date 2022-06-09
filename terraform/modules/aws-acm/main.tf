##
# The configuration for this backend will be filled in by Terragrunt
#
# https://terragrunt.gruntwork.io/docs/features/keep-your-remote-state-configuration-dry/
#
terraform {
  backend "s3" {}
}

#
# ACM
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate
#
resource "aws_acm_certificate" "cert" {
  domain_name       = "example.com"
  validation_method = "DNS"

  tags = {
    Name = "${local.name}-${var.deployment_id}",
    Owner   = basename(data.aws_caller_identity.current.arn),
    Project = local.name,
  }

  lifecycle {
    create_before_destroy = true
  }
}