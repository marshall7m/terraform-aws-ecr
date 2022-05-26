locals {
  repo_url = var.repo_url != null ? var.repo_url : aws_ecr_repository.this[0].repository_url
  # if path is a directory get filepaths within directory
  trigger_file_paths = flatten([for p in var.trigger_build_paths : try(fileexists(p), false) ? [p] :
    # use formatlist() to join directory and file name list since fileset doesn't give full path
    formatlist("${p}/%s", fileset(p, "*"))
  ])
  full_image_url  = "${local.repo_url}:${var.tag}"
  build_arg_flags = join(" ", [for key, value in var.build_args : "--build-arg ${key}=${value}"])
  cache           = var.cache ? "" : "--no-cache"

  region = var.repo_url != null ? split(".", var.repo_url)[3] : data.aws_region.current.name

  # create unique identifier for local docker image
  name = "${var.name}-${random_string.local_image.id}"
}

data "aws_region" "current" {}

resource "random_string" "local_image" {
  length  = 8
  lower   = true
  upper   = false
  special = false
}

resource "aws_ecr_repository" "this" {
  count                = var.create_repo ? 1 : 0
  name                 = var.name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.repo_tags
}

resource "aws_ecr_repository_policy" "this" {
  count      = var.create_repo && var.codebuild_access ? 1 : 0
  repository = aws_ecr_repository.this[0].name

  policy = data.aws_iam_policy_document.this[0].json
}

data "aws_iam_policy_document" "this" {
  count = var.codebuild_access ? 1 : 0
  statement {
    sid    = "CodeBuildAccess"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}


resource "null_resource" "build" {
  triggers = { for file in local.trigger_file_paths : basename(file) => filesha256(file) }

  provisioner "local-exec" {
    command     = <<EOF

docker build ${local.cache} -t ${local.name} ${var.source_path} ${local.build_arg_flags}

aws ecr get-login-password --region ${local.region} | docker login --username AWS --password-stdin ${local.repo_url}
docker tag ${local.name} ${local.full_image_url}
docker push ${local.full_image_url}

      EOF
    interpreter = ["bash", "-c"]
  }
}