variable "ecr_address" {
  description = "Address of the AWS ECR to create the image under"
  type        = string
  sensitive   = true
}

variable "ecr_user_name" {
  description = "User name of the AWS ECR"
  type        = string
}

variable "ecr_password" {
  description = "Password of the AWS ECR"
  type        = string
  sensitive   = true
}

variable "img_name" {
  description = "Name of the ECR image"
  type        = string
}

variable "path" {
  description = "Path to the Dockerfile used for the build"
  type        = string
}

variable "tag" {
  description = "Tag to add to the ECR image"
  type        = string
}

variable "build_args" {
  description = "Key-value pairs of build-time arguments"
  type        = map(string)
  default     = {}
}

variable "label" {
  description = "Key-value pairs of image labels"
  type        = map(string)
  default     = {}
}