# Create AWS instance
resource "aws_instance" "beacon" {
  ami                  = "${var.ami}"
  instance_type        = "t2.micro"
  subnet_id            = "${module.vpc.subnet}"
  security_groups      = ["${aws_security_group.beacon.id}"]
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

data "kubectl_file_documents" "namespace" {
    content = file("../manifests/argocd/namespace.yaml")
} 

data "kubectl_file_documents" "argocd" {
    content = file("../manifests/argocd/install.yaml")
}

resource "kubectl_manifest" "namespace" {
    count     = length(data.kubectl_file_documents.namespace.documents)
    yaml_body = element(data.kubectl_file_documents.namespace.documents, count.index)
    override_namespace = "argocd"
}

resource "kubectl_manifest" "argocd" {
    depends_on = [
      kubectl_manifest.namespace,
    ]
    count     = length(data.kubectl_file_documents.argocd.documents)
    yaml_body = element(data.kubectl_file_documents.argocd.documents, count.index)
    override_namespace = "argocd"
}

data "kubectl_file_documents" "my-nginx-app" {
    content = file("../manifests/argocd/my-nginx-app.yaml")
}

resource "kubectl_manifest" "my-nginx-app" {
    depends_on = [
      kubectl_manifest.argocd,
    ]
    count     = length(data.kubectl_file_documents.my-nginx-app.documents)
    yaml_body = element(data.kubectl_file_documents.my-nginx-app.documents, count.index)
    override_namespace = "argocd"
}