provider "aws" {
  region = var.AWS_REGION
}
output "test_output_subnets" {
  value = data.aws_subnets.pubs.ids
}