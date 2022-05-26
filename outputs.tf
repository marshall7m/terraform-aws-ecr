output "repo_url" {
  description = "AWS ECR repo URL"
  value       = local.repo_url
}

output "full_image_url" {
  description = "AWS ECR image full URL `<aws-id>.dkr.ecr.<region>.amazonaws.com/<repo-name>:<tag>)`"
  value       = local.full_image_url
}