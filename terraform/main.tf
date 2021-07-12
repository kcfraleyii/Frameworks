# Create AWS instance
resource "aws_instance" "beacon" {
  ami                  = "${var.ami}"
  instance_type        = "t2.micro"
  subnet_id            = "${module.vpc.subnet}"
  security_groups      = ["${aws_security_group.beacon.id}","${module.vpc.allow_from_bastion_sg}"]
  iam_instance_profile = "beacon-role"

  tags {
    Name               = "beacon-${var.environment}"
    Environment        = "${var.environment}"
  }
}

# Create AWS Instance Security Group
resource "aws_security_group" "beacon" {
  name        = "beacon"
  description = "Allow web traffic from the internet"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create VPC
module "vpc" {
  source           = "../modules/vpc"
  aws_region       = "${var.aws_region}"
  environment      = "${var.environment}"
  vpc_cidr         = "${var.vpc_cidr}"
  private_subnet   = "${var.private_subnet}"
  bastion_ami      = "${var.ami}"
}