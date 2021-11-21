module "ecs_cluster_test" {
  source               = "./modules/ecs_cluster"
  aws_region           = var.aws_region
  aws_account_id       = var.aws_account_id
  environment          = "test"
  name_prefix          = "launchpad"

  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.public_subnet_ids
  dns_name                = "test.poc.clearchannel.io"
  zone_id                 = aws_route53_zone.poc.zone_id

  tags   = local.launchpad_tags
}
