# Require TF version to be same as or greater than 0.12.16
terraform {
  required_version = ">=0.12.16"
/*
  backend "s3" {
    bucket         = "kyler-codebuild-demo-terraform-tfstate"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "codebuild-dynamodb-terraform-locking"
    encrypt        = true
  }
*/
}

# Download any stable version in AWS provider of 2.36.0 or higher in 2.36 train
provider "aws" {
  region  = "ap-south-1"
  version = "~> 2.36.0"
/*
  assume_role {
    # Remember to update this account ID to yours
    role_arn     = "arn:aws:iam::718626770228:role/TerraformAssumedIamRole"
    session_name = "terraform"
  }
*/
}

## Build an S3 bucket and DynamoDB for Terraform state and locking
module "bootstrap" {
  source                              = "./modules/bootstrap"
  s3_tfstate_bucket                   = "mihir6598-terraform-state"
  s3_logging_bucket_name              = "mihir6598-terraform-log"
  dynamo_db_table_name                = "mihir6598-terraform-dynamo"
  codebuild_iam_role_name             = "mihir6598-terraform-role"
  codebuild_iam_role_policy_name      = "mihir6598-terraform-policy"
  terraform_codecommit_repo_arn       = module.codecommit.terraform_codecommit_repo_arn
  tf_codepipeline_artifact_bucket_arn = module.codepipeline.tf_codepipeline_artifact_bucket_arn
}

## Build a CodeCommit git repo
module "codecommit" {
  source          = "./modules/codecommit"
  repository_name = "CodeCommitTerraform"
}

## Build CodeBuild projects for Terraform Plan and Terraform Apply
module "codebuild" {
  source                                 = "./modules/codebuild"
  codebuild_project_terraform_plan_name  = "TerraformPlan"
  codebuild_project_terraform_apply_name = "TerraformApply"
  s3_logging_bucket_id                   = module.bootstrap.s3_logging_bucket_id
  codebuild_iam_role_arn                 = module.bootstrap.codebuild_iam_role_arn
  s3_logging_bucket                      = module.bootstrap.s3_logging_bucket
}

## Build a CodePipeline
module "codepipeline" {
  source                               = "./modules/codepipeline"
  tf_codepipeline_name                 = "TerraformCodePipeline"
  tf_codepipeline_artifact_bucket_name = "mihir6598-terraform-artifact-bucket-name"
  tf_codepipeline_role_name            = "mihir6598-terraform-CodePipelineIamRole"
  tf_codepipeline_role_policy_name     = "mihir6598-terraform-CodePipelineIamRolePolicy"
  terraform_codecommit_repo_name       = module.codecommit.terraform_codecommit_repo_name
  codebuild_terraform_plan_name        = module.codebuild.codebuild_terraform_plan_name
  codebuild_terraform_apply_name       = module.codebuild.codebuild_terraform_apply_name
}
