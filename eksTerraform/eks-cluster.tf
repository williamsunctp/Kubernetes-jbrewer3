module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0.4"

  cluster_name    = var.ClusterName
  cluster_version = "1.24"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = [
     for s in data.aws_subnet.subnet-ids : s.id
  ]
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = var.ManagedNGName

      instance_types = ["t3.medium"]
      capacity_type = "DEMAND"
      min_size     = 1
      max_size     = 3
      desired_size = 2
      subnet_ids = [
        "${element(module.vpc.private_subnets, 0)}", "${element(module.vpc.public_subnets, 0)}"

        ]
      vpc_security_group_ids = []
    }
  }
 }

}

