terraform {
  before_hook "before_hook" {
    commands = ["validate", "plan", "apply"]
    execute  = ["bash", "-c", local.before_hook]
  }
}

locals {
  before_hook = <<-EOF
  if [[ -z $SKIP_TFENV ]]; then 
  echo Scanning Terraform files for Terraform binary version constraint 
  tfenv use min-required || tfenv install min-required \
  && tfenv use min-required
  else 
  echo Skip scanning Terraform files for Terraform binary version constraint
  tfenv version-name
  fi
  EOF
}

remote_state {
  backend = "local"
  config  = {}
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}