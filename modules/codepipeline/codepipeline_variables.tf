variable "tf_codepipeline_artifact_bucket_name" {
  description = "Name of the TF CodePipeline S3 bucket for artifacts"
}
variable "tf_codepipeline_role_name" {
  description = "Name of the Terraform CodePipeline IAM Role"
}
variable "tf_codepipeline_role_policy_name" {
  description = "Name of the Terraform IAM Role Policy"
}
variable "tf_codepipeline_name" {
  description = "Terraform CodePipeline Name"
}
variable "codebuild_terraform_plan_name" {
  description = "Terraform plan codebuild project name"
}
variable "codebuild_terraform_apply_name" {
  description = "Terraform apply codebuild project name"
}

variable "git_owner" {
  description = "Git userid"
}

variable "git_repo" {
  description = "Git repo name"
}
variable "git_branch" {
  description = "Git branch name"
}

variable "git_token" {
  description = "Git token"
}