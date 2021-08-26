# Create AWS Instance
resource "aws_instance" "server" {
  ami                  = "${var.ami}"
  instance_type        = "t2.micro"
  subnet_id            = "${module.vpc.subnet}"
  security_groups      = ["${aws_security_group.beacon.id}"]
  iam_instance_profile = "server-role"

  tags {
    Name               = "server-${var.environment}"
    Environment        = "${var.environment}"
  }
}

# Create AWS Security Group
resource "aws_security_group" "server" {
  name        = "server"
  description = "Allow web traffic from the internet"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create AWS VPC
module "vpc" {
  source           = "../modules/vpc"
  aws_region       = "${var.aws_region}"
  environment      = "${var.environment}"
  vpc_cidr         = "${var.vpc_cidr}"
  private_subnet   = "${var.private_subnet}"
  bastion_ami      = "${var.ami}"
}

#Define AWS K8s Namespace
data "kubectl_file_documents" "namespace" {
    content = file("../manifests/argocd/namespace.yaml")
} 

#Define ArgoCD for K8s Cluster
data "kubectl_file_documents" "argocd" {
    content = file("../manifests/argocd/install.yaml")
}

#Create Defined Namespace
resource "kubectl_manifest" "namespace" {
    count     = length(data.kubectl_file_documents.namespace.documents)
    yaml_body = element(data.kubectl_file_documents.namespace.documents, count.index)
    override_namespace = "argocd"
}

#Apply/Install Defined Manifest
resource "kubectl_manifest" "argocd" {
    depends_on = [
      kubectl_manifest.namespace,
    ]
    count     = length(data.kubectl_file_documents.argocd.documents)
    yaml_body = element(data.kubectl_file_documents.argocd.documents, count.index)
    override_namespace = "argocd"
}

#Define ArgoCD Application
data "kubectl_file_documents" "my-nginx-app" {
    content = file("../manifests/argocd/my-nginx-app.yaml")
}

#Apply Defined Manifest for Application running on ArgoCD
resource "kubectl_manifest" "my-nginx-app" {
    depends_on = [
      kubectl_manifest.argocd,
    ]
    count     = length(data.kubectl_file_documents.my-nginx-app.documents)
    yaml_body = element(data.kubectl_file_documents.my-nginx-app.documents, count.index)
    override_namespace = "argocd"
}