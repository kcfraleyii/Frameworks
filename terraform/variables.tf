#Global Variables
variable "aws_region" {
    description = "AWS Region"
    type        = string
    default     = "us-central-1"
}

variable "ami" {
    description = "Instance AMI"
    type        = string
    default     = "ami-***"
}

variable "environment" {
    description = "Ephemeral Workflow Environment"
    type        = string
    default     = "ephemeral-dev"
}

variable "vpc_cidr" {
    description = "Default CIDR block"
    type        = string
    default     = ["10.0.0.0/24"]
}

variable "private_subnet" {
    description = "Default Private Subnet"
    type        = string
    default     = ["10.128.0.0/24"]
}