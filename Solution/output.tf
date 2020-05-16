output "webservers" {
  value = [for server in aws_instance.ec2 : server.public_dns]
}

output "loadbalancer" {
  value = aws_lb.alb.dns_name
}
