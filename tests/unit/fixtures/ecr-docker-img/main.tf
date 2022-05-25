locals {
  repo_name = "mut-terrafomr-aws-ecr"
  tag       = "latest"
}

module "mut_ecr_docker_img" {
  source              = "../../../../modules//ecr-docker-img"
  cache               = false
  create_repo         = true
  source_path         = "./"
  repo_name           = local.repo_name
  tag                 = local.tag
  trigger_build_paths = var.trigger_build_paths
  build_args = {
    "foo" = "doo"
  }
}