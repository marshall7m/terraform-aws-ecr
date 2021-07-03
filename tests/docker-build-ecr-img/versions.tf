terraform {
  required_version = ">=0.15.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.22"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.13.0"
    }
  }
}