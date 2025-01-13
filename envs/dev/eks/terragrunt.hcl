terraform {
  source = "git::git@github.com:dirtydriver/terraform-modules.git//modules/aws/eks?ref=main"
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"

  # Ensure outputs are fetched from the VPC module
  skip_outputs = false

  # Mock outputs are used during planning if the actual outputs are not available
  mock_outputs = {
    private_subnets_ids = ["subnet-1234", "subnet-5678"]
    vpc_id              = "vpc-123456"
  }
}

inputs = {
  cluster_name              = "eks-${include.env.locals.env}"
  aws_region                = "eu-central-1"
  subnet_ids                = dependency.vpc.outputs.private_subnets_ids
  vpc_id                    = dependency.vpc.outputs.vpc_id
  endpoint_private_access   = false   # Set to true or false based on your requirements
  endpoint_public_access    = true  # Set to true or false based on your requirements
  bastion_ip                = "1.2.3.4/32"  # Replace with your bastion host IP if needed
  cluster_version           = "1.31"
  tags = {
    Environment = include.env.locals.env
    Project     = "EKS"
  }
}
