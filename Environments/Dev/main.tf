# responsible for executing the proper modules 

provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "../../Modules/Networking"

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = "${var.aws_region}b"
}
