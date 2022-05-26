# Terraform AWS ECR

Terraform modules that builds and uploads a Docker image to an ECR repository

## Machine Requirements

The following requirements are for the machine that is creating the Terraform module:

- Docker binary must be installed
- Docker daemon must be running

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 2.23 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.23 |
| null | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| build\_args | Map of build arguments to supply at build time | `map(string)` | `{}` | no |
| cache | Determines if docker build should use a cache (`--no-cache` flag) | `bool` | `true` | no |
| codebuild\_access | Determines if CodeBuild services are allowed to pull images from the ECR repo | `bool` | `false` | no |
| create\_repo | Determines if this module should create an AWS ECR repo | `bool` | `false` | no |
| name | Name of the AWS ECR repository to create and push the docker image to | `string` | `"ecr"` | no |
| repo\_tags | AWS tags for the ECR repository | `map(string)` | `{}` | no |
| repo\_url | Pre-existing AWS ECR repository URL to push the Docker image to (format: aws\_account\_id.dkr.ecr.region.amazonaws.com/repositoryName) | `string` | `null` | no |
| source\_path | Path to Docker context | `string` | n/a | yes |
| tag | Tag for the Docker image | `string` | `"latest"` | no |
| trigger\_build\_paths | List of directory/file paths that when modified will trigger a new build | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| full\_image\_url | AWS ECR image full URL `<aws-id>.dkr.ecr.<region>.amazonaws.com/<repo-name>:<tag>)` |
| repo\_url | AWS ECR repo URL |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->