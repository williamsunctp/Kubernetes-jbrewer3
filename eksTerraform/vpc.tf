module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = "EKSVPC"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)
  #  azs  = data.aws_availability_zones.available.names 

  private_subnets = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
  public_subnets = ["10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]

  # private_subnets = "${aws_subnet.private.*.cidr_block}"
  
  # public_subnets = "${aws_subnet.public.*.cidr_block}"

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
    "Tier"                                        = "Public"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
    "Tier"                                        = "Private"
  }
}
