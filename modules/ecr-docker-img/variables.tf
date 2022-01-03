variable "source_path" {
  description = "Path to Docker context"
  type        = string
}

variable "trigger_build_paths" {
  description = "List of directory/file paths that when modified will trigger a new build"
  type        = list(string)
  default     = null
}

variable "tag" {
  description = "Tag for the Docker image"
  type        = string
  default     = "latest"
}

variable "repo_url" {
  description = "Pre-existing AWS ECR repository URL to push the Docker image to (Used mainly for cross-account repos)"
  type        = string
  default     = null
}

variable "create_repo" {
  description = "Determines if this module should create an AWS ECR repo"
  type        = bool
  default     = false
}

variable "repo_name" {
  description = "Name of the AWS ECR repository to create and push the docker image to"
  type        = string
  default     = null
}

variable "codebuild_access" {
  description = "Determines if CodeBuild services are allowed to pull images from the ECR repo"
  type        = bool
  default     = false
}

variable "build_args" {
  description = "Map of build arguments to supply at build time"
  type        = map(string)
  default     = {}
}