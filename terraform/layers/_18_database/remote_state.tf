data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "msk-dev-terraform-state"
    key    = "${var.environment}/network/terraform.tfstate"
    region = local.aws_region
  }
}
