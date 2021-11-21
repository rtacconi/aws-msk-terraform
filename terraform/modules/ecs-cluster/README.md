## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_cloudwatch_log_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_kms_key.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_route53_record.alias_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.lb_internet_traffic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS account ID | `any` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to launch servers | `any` | n/a | yes |
| <a name="input_cidr_blocks_ingress"></a> [cidr\_blocks\_ingress](#input\_cidr\_blocks\_ingress) | CIDR block for inbound traffic | `list` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | DNS name used by the certificate | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Current environment | `string` | `"dev"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | A prefix used for naming resources. | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Public subnets to deploy the ALB | `list` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of common tags to apply to resources | `map` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where the LB is deployed | `string` | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | DNS zone ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alias_record"></a> [alias\_record](#output\_alias\_record) | n/a |
| <a name="output_aws_lb_arn"></a> [aws\_lb\_arn](#output\_aws\_lb\_arn) | n/a |
| <a name="output_aws_lb_listener_arn"></a> [aws\_lb\_listener\_arn](#output\_aws\_lb\_listener\_arn) | n/a |
| <a name="output_ecs_cluster_id"></a> [ecs\_cluster\_id](#output\_ecs\_cluster\_id) | n/a |
| <a name="output_lb_aws_security_group_id"></a> [lb\_aws\_security\_group\_id](#output\_lb\_aws\_security\_group\_id) | n/a |
