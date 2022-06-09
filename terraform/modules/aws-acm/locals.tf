locals {
  name = "terraform-project-${var.env}"

  tags = {
    "terraform" = "true",
    "env"       = var.env,
    "project"   = "terraform-project"
    "owner"     = "default"
  }
}