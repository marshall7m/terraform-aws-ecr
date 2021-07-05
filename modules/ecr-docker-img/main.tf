locals {
  repo_url = try(data.aws_ecr_repository.this[0].repository_url, module.ecr[0].ecr_repo_url)
  # if path is a directory get filepaths within directory
  trigger_file_paths = flatten([for p in var.trigger_build_paths : try(fileexists(p), false) ? [p] :
    # use formatlist() to join directory and file name list since fileset doesn't give full path
    formatlist("${p}/%s", fileset(p, "*"))
  ])
  full_image_url = "${local.repo_url}:${var.tag}"
}

data "aws_region" "current" {}

module "ecr" {
  source           = "..//repo"
  count            = var.create_repo ? 1 : 0
  name             = var.repo_name
  codebuild_access = var.codebuild_access
}

data "aws_ecr_repository" "this" {
  count = var.create_repo != true ? 1 : 0
  name  = var.repo_name
}

resource "null_resource" "build" {
  triggers = { for file in local.trigger_file_paths : basename(file) => filesha256(file) }

  provisioner "local-exec" {
    command     = <<EOF

docker build -t ${var.repo_name} ${var.source_path}

aws ecr get-login-password --region ${data.aws_region.current.name} | docker login --username AWS --password-stdin ${local.repo_url}
docker tag ${var.repo_name} ${local.full_image_url}
docker push ${local.full_image_url}

      EOF
    interpreter = ["bash", "-c"]
  }
}