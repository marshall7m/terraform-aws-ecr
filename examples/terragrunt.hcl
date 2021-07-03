include {
  path = find_in_parent_folders()
}

terraform {
  source = "../modules//repo"
}

inputs = {
  create_repo         = true
  ecr_repo_url_to_ssm = true
  name                = "foo"
  ssm_key             = "mut-terraform-aws-ecr-repo-address"
}