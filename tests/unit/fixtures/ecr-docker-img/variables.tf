variable "trigger_build_paths" {
  description = "List of directory/file paths that when modified will trigger a new build"
  type        = list(string)
  default     = []
}