
# module "alb" {
#   source  = "terraform-aws-modules/alb/aws"
#   version = "~> 6.0"

#   name = var.namespace

#   load_balancer_type = "application"

#   vpc_id          = module.vpc.vpc_id
#   subnets         = module.vpc.public_subnets
#   security_groups = [aws_security_group.allow_http.id]

#   target_groups = [
#     {
#       name_prefix      = "pref-"
#       backend_protocol = "HTTP"
#       backend_port     = 80
#       target_type      = "instance"
#       targets = [
#         for id in var.ec2_instance_id : {
#           port      = 80
#           target_id = id
#         }
#       ]
#     }
#   ]

#   http_tcp_listeners = [
#     {
#       port               = 80
#       protocol           = "HTTP"
#       target_group_index = 0
#     }
#   ]

# }
