terraform {
  source = "git::git@github.com:dirtydriver/terraform-modules.git//modules/aws/eks?ref=main"
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

inputs = {
    cluster_name = "eks-dev"
    vpc_id = dependency.vpc.outputs.vpc_id
    subnet_ids = dependency.vpc.outputs.private_subnets_ids
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id = 123
    private_subnet_ids = ["subnet-1234", "subnet-5678"]
  }

}

