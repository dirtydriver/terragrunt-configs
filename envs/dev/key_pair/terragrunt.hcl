terraform {
  source = "git::git@github.com:dirtydriver/terraform-modules.git//modules/aws/aws_key_pair?ref=main"
}

include "env" {

  path = find_in_parent_folders("env.hcl")
  expose = true
  merge_strategy = "no_merge" 
}

include "root" {
  path = find_in_parent_folders()
}


inputs = {
    
      key_name = "${include.env.locals.env}-ssh-key"
      put_priv_in_outputs = true
    
}