variable "repository_names" {
  description = "List of ECR repository names to create"
  type        = list(string)
}

variable "image_tag_mutability" {
  description = "Tag mutability setting for the repository. Options: MUTABLE or IMMUTABLE"
  type        = string
  default     = "IMMUTABLE"
}

variable "scan_on_push" {
  description = "Enable or disable vulnerability scanning on image push"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to the repository"
  type        = map(string)
  default     = {}
}
