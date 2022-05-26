locals {
  repo_name = "mut-terrafomr-aws-ecr-${basename(path.cwd)}"
  tag       = "latest"
}

resource "aws_ecr_repository" "this" {
  name                 = local.repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

module "mut_ecr_docker_img" {
  source              = "../../..//"
  cache               = false
  create_repo         = false
  source_path         = "./"
  repo_url            = aws_ecr_repository.this.repository_url
  tag                 = local.tag
  trigger_build_paths = var.trigger_build_paths
  build_args = {
    "foo" = "doo"
  }
}