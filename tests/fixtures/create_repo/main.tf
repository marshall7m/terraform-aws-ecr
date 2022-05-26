locals {
  repo_name = "mut-terrafomr-aws-ecr-${basename(path.cwd)}"
  tag       = "latest"
}

module "mut_ecr_docker_img" {
  source              = "../../..//"
  cache               = false
  create_repo         = true
  source_path         = "./"
  name                = local.repo_name
  tag                 = local.tag
  trigger_build_paths = var.trigger_build_paths
  build_args = {
    "foo" = "doo"
  }
}