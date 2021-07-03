locals {
    mut = "docker_ecr_img"
}

resource "aws_ecr_repository" "this" {
  name                 = local.mut
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_ecr_authorization_token" "this" {}

module "mut_docker_ecr_img" {
    source = "../../modules//docker-build-ecr-img"

    ecr_address = aws_ecr_repository.this.repository_url
    ecr_user_name = data.aws_ecr_authorization_token.this.user_name
    ecr_password = data.aws_ecr_authorization_token.this.password
    test = data.aws_ecr_authorization_token.this
    img_name = "test"
    tag = "latest"
    path = "."
    build_args = {
        SAMPlE = "${path.cwd}/foo.txt"
    }
    label = {
        mut = local.mut
    }
}
