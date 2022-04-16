locals {
  network_acls = {
    default_inbound = [
      {
        rule_number = 900
        rule_action = "allow"
        from_port   = 0
        to_port     = 65535
        protocol    = -1
        cidr_block  = "0.0.0.0/0"
      },
    ]
    default_outbound = [
      {
        rule_number = 900
        rule_action = "allow"
        from_port   = 0
        to_port     = 65535
        protocol    = -1
        cidr_block  = "0.0.0.0/0"
      },
    ]
  }
}
data "aws_availability_zones" "available" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.namespace}-vpc"
  cidr = "172.16.0.0/16"

  azs             = data.aws_availability_zones.available.names
  private_subnets = ["172.16.0.0/19", "172.16.32.0/19", "172.16.64.0/19"]
  public_subnets  = ["172.16.128.0/20", "172.16.144.0/20", "172.16.160.0/20"]

  manage_default_network_acl    = true
  private_dedicated_network_acl = false
  public_dedicated_network_acl  = true
  public_inbound_acl_rules      = local.network_acls["default_inbound"]
  public_outbound_acl_rules     = local.network_acls["default_outbound"]

  tags = var.tags
  vpc_tags = {
    Namespace = "${var.namespace}-vpc"
  }
  public_subnet_tags = {
    Namespace                = "${var.namespace}-public-subnet"
    "kubernetes.io/role/elb" = "1"

  }
  private_subnet_tags = {
    Namespace = "${var.namespace}-private-subnet"
  }

  # enable_ipv6 = true
  # enable_vpn_gateway = true
  enable_nat_gateway = true
  single_nat_gateway = false
  # one_nat_gateway_per_az = true
  reuse_nat_ips       = true
  external_nat_ip_ids = aws_eip.nat.*.id
}

resource "aws_eip" "nat" {
  count = 3

  vpc = true
}
