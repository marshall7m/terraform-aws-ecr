module "mut_ecr_docker_img" {
  source = "../../modules//ecr-docker-img"

  create_repo = true
  source_path = "./"
  repo_name   = "test"
  tag         = "latest"
  trigger_build_paths = [
    "${path.module}/Dockerfile",
    "${path.module}/foo.txt"
  ]
}

/* TODO: Create terraform tests
    - check if ecr repo was created with img
    - check if file hashes were created for directory inputs
*/