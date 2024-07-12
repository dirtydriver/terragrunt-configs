terraform {
  source = "git::git@github.com:dirtydriver/terraform-modules.git//modules/aws/vpc?ref=main"
}

include "env" {

  path = find_in_parent_folders("env.hcl")
  expose = true
  merge_strategy = false 
}

inputs = {
    tags = {
      Name = "${env.local.env}"
    }
    vpc_cdir = "10.0.0.0/16"
    public_subnet_cdirs = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
    private_subnet_cdirs = ["10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]
    azs = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}