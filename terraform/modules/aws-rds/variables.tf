variable "env" {
  type = string
}

variable "vpc_id" {
  description = "The ID for the VPC. Default value is a valid CIDR"
  type        = string
}

variable "subnet_ids" {
  description = "The private subnet IDs to deploy to"
  type        = list(string)
}

variable "aws_region" {
  type = string
}

variable "deployment_id" {
  type    = string
  default = "000"
}

variable "rds_password" {
  description = "Password for the RDS instance."
  type        = string
  default     = "Password123"
}

variable "display_db_pass" {
  description = "Shouold terraform output the generated heimdall database password to stdout?"
  type        = bool
  default     = true
}