provider "docker" {
    # host = "unix:///var/run/docker.sock"

    registry_auth {
        address = var.ecr_address
        username = "AWS"
        password = var.ecr_password
    }
}

resource "docker_image" "this" {
  name = "test"
  build {
    path = var.path
    tag  = [var.tag]
    build_arg = var.build_args
    label = var.label
  }
}

# resource "docker_registry_image" "this" {
#   name = var.img_name

#   build {
#     context = var.path
#     build_args = var.build_args
#     auth_config {
#       registry_token = var.test.authorization_token
#     #   user_name = var.ecr_user_name
#     #   password = var.ecr_password
#     }
#   }
# }

variable "test" {
  
}