module "network" {
  source = "../../modules/network"
  vpc_cidr_block = "10.1.0.0/16"
  env = "Dev"
  vpc_name = "Dev-VPC"
  public_subnet_cidr_blocks = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24"]
  private_subnet_cidr_blocks = ["10.1.5.0/24", "10.1.6.0/24"]
  availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c", "us-east-2a"]
}