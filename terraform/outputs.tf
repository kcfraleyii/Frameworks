# VPC
output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "allow_from_bastion_sg" {
  value = "${module.vpc.allow_from_bastion_sg}"
}