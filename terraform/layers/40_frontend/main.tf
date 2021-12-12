resource "aws_acm_certificate" "default" {
  domain_name = "reactjs.recursivelabs.cloud"
  subject_alternative_names = ["*.reactjs1.recursivelabs.cloud"]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }

  # tags = merge(
  #   var.tags,
  #   {
  #     Name = "${var.project}-${var.environment}"
  #   },
  # )
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.default.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = "Z3N5HXM6O20SNS"
}

resource "aws_acm_certificate_validation" "default" {
  certificate_arn = aws_acm_certificate.default.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}

module "cloudfront_s3_website_with_domain" {
    source                 = "../../modules/terraform-aws-cloudfront-s3-website"
    hosted_zone            = "recursivelabs.cloud"
    domain_name            = "reactjs1.recursivelabs.cloud"
    acm_certificate_arn    = aws_acm_certificate.default.arn
    upload_sample_file     = true
}
