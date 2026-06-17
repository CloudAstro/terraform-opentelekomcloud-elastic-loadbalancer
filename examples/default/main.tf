module "vpc" {
  source  = "CloudAstro/vpc/opentelekomcloud"
  version = "1.1.0"
  name    = "vpc-example"
  cidr    = "10.10.0.0/24"
}

module "subnet" {
  source     = "CloudAstro/vpc-subnet/opentelekomcloud"
  version    = "1.1.0"
  name       = "snet-example"
  cidr       = "10.10.0.0/26"
  gateway_ip = "10.10.0.1"
  vpc_id     = module.vpc.vpc_v1.id
}

module "elb" {
  source        = "../../"
  vip_subnet_id = module.subnet.vpc_subnet.subnet_id
}
