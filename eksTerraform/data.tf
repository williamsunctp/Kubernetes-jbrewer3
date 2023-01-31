data "aws_subnets" "subnets" {
    filter {
        name = "vpc-id"
        values = [module.vpc.vpc_id]
    }
}



data "aws_subnet" "subnet-ids" {
    for_each = toset(data.aws_subnets.subnets.ids)
    id = each.value
}