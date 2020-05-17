resource "aws_default_vpc" "vpc" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "vpc" {
  for_each          = zipmap(var.availability_zones, var.availability_zones)
  availability_zone = each.key
  tags = {
    Name = "Default subnet for ${each.key}"
  }
}
