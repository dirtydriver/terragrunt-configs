terraform {
  source = "git::git@github.com:dirtydriver/terraform-modules.git//modules/aws/vpc?ref=main"
}

remote_state {
  backend = "s3"
  config = {
    bucket = "petruskaa-dev"
    key    = "envs/dev/vpc/terraform.tfstate"
    region = "eu-central-1"
  }
}
inputs = {
    tags = {
      Name = "Demo Vpc"
      User = "petruskaa"
    }
    vpc_cdir = "10.0.0.0/16"
    public_subnet_cdirs = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
    private_subnet_cdirs = ["10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]
    azs = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}