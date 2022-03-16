resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = var.vpc.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # cidr_blocks      = [aws_vpc.main.cidr_block]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_all"
  }
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                    = var.namespace
  cluster_version                 = "1.21"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  # cluster_addons = {
  #   coredns = {
  #     resolve_conflicts = "OVERWRITE"
  #   }
  #   kube-proxy = {}
  #   vpc-cni = {
  #     resolve_conflicts = "OVERWRITE"
  #   }
  # }

  # cluster_encryption_config = [{
  #   provider_key_arn = "ac01234b-00d9-40f6-ac95-e42345f78b00"
  #   resources        = ["secrets"]
  # }]

  vpc_id     = var.vpc.vpc_id
  subnet_ids = split(", ", "${join(", ", var.vpc.private_subnets)}")
  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    disk_size              = 50
    instance_types         = ["t3.small"]
    vpc_security_group_ids = aws_security_group.allow_all.*.id


  }

  eks_managed_node_groups = {
    first = {
      min_size     = 2
      max_size     = 3
      desired_size = 2

      # capacity_type  = "SPOT"
      labels = var.tags
      # {
      #   Environment = "test"
      #   GithubRepo  = "terraform-aws-eks"
      #   GithubOrg   = "terraform-aws-modules"
      # }
      # taints = {
      #   dedicated = {
      #     key    = "dedicated"
      #     value  = "gpuGroup"
      #     effect = "NO_SCHEDULE"
      #   }
      # }
      # tags = {
      #   ExtraTag = "example"
      # }
    }
  }

}
