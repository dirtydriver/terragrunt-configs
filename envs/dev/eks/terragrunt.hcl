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

inputs = {
    cluster_name = "eks-${include.env.locals.env}"
    subnet_ids = dependency.vpc.outputs.private_subnets_ids
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    private_subnets_ids = ["subnet-1234", "subnet-5678"]
  }

}

