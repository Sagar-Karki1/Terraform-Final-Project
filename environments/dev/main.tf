module "network" {
  source = "../../modules/network"
  vpc_cidr_block = "10.1.0.0/16"
  env = "Dev"
  vpc_name = "Dev-VPC"
  public_subnet_cidr_blocks = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24"]
  private_subnet_cidr_blocks = ["10.1.5.0/24", "10.1.6.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
}

module "sg" {
  source = "../../modules/sg"
  env = "Dev"
  private_subnet_cidrs = module.network.private_subnet_cidrs
  vpc_id = module.network.vpc_id
}

module "compute" {
  source = "../../modules/compute"
  keypair_name = "WebServer-kp"
  ami_id = "ami-02dfbd4ff395f2a1b"
  instance_type = "t3.micro"
  env = "Dev"
  public_subnet_ids = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
  webserver_sg_id = module.sg.webserver_sg_id
  bastion_sg_id = module.sg.bastion_sg_id
  private_sg_id = module.sg.private_sg_id
}

module "alb" {
  source = "../../modules/alb"
  subnet_ids = module.network.public_subnet_ids
  vpc_id = module.network.vpc_id
  env = "Dev"
  instance_ids = module.compute.public_instance_ids
  alb_sg_id = module.sg.alb_sg_id
}