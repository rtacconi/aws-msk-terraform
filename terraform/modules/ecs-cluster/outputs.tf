output "aws_lb_arn" {
  value = aws_lb.alb.arn
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.cluster.id
}

output "lb_aws_security_group_id" {
  value = aws_security_group.lb_internet_traffic.id
}

output "aws_lb_listener_arn" {
  value = aws_lb_listener.listener.arn
}

output "alias_record" {
  value = aws_route53_record.alias_record.name
}
