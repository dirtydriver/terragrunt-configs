terraform {
  source = "git::git@github.com:dirtydriver/terraform-modules.git//modules/aws/eks_node_group?ref=main"
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "eks" {
  config_path = "../eks"

  skip_outputs = false  # Set to true if EKS cluster module hasn't been applied
  mock_outputs = {
    cluster_name = "mockoutputs_eks"
    node_role_arn = "mockoutputs_arn"
  }
}

dependency "vpc" {
  config_path = "../vpc"

  skip_outputs = false

  mock_outputs = {
    private_subnets_ids = ["subnet-1234", "subnet-5678"]
  }
}

inputs = {
  eks_cluster_name = dependency.eks.outputs.cluster_name
  node_role_arn    = dependency.eks.outputs.node_role_arn
  tags             = {
    Environment = include.env.locals.env
    Project     = "EKS"
  }
  node_groups = {
    # Define your node groups here
    ng1 = {
      desired_size    = 2
      max_size        = 5
      min_size        = 1
      instance_types  = ["t2.small"]
      max_unavailable = 1
      subnets         = dependency.vpc.outputs.private_subnets_ids
      tags = {
        Name = "ng1"
      }
    }
    # Add more node groups if needed
  }
}