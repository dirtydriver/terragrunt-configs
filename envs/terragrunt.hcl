remote_state {
  backend = "s3"
  config = {
    bucket = "terragrunt"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "eu-central-1"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "aws" {
    region = "eu-central-1"
}
EOF
}