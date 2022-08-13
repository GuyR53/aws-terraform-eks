#  Creates the network topology
module "networking" {
  source = "./modules/networking"
  # Passing the environment
  environment          = var.environment
  # Passing vpc_cidr
  vpc_cidr             = var.vpc_cidr
  # Passing Public subnet cidr AZ1
  public_subnet_cidr_AZ1  = var.public_subnet_cidr_AZ1
    # Passing Public subnet cidr AZ2
  public_subnet_cidr_AZ2  = var.public_subnet_cidr_AZ2
  # Passing Private subnet cidr
  private_subnet_cidr = var.private_subnet_cidr
}

module "eks" {
  source = "./modules/eks"
  subnetidAZ1 = module.networking.public_subnet_id_az1
  subnetidAZ2 = module.networking.public_subnet_id_az2
  publicsecuritygroupid = module.networking.public_security_group
}

# Reuse the code that creates ec2 instances in app subnet
module "ec2" {
  source = "./modules/ec2"
  # Creating ec2s with the names and numbers as we pass in the list, the last machine is configuration machine with public IP
  vm_names = ["ConfigurationMachine"]
  # Passing the app subnetID, creating the machines in the right subnet
  public_subnet_id_az1 = module.networking.public_subnet_id_az1
  # Passing publickey for the machines
  public_key = var.public_key
  # Passing public security group
  public_security_group = module.networking.public_security_group
  # Passing the environment
  environment = var.environment

}