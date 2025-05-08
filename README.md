Step by step process to deploy an EKS (Elastic Kubernetes Service) cluster on AWS using Jenkins and Terraform.

## Workflow Overview
Terraform defines the EKS infrastructure.

Jenkins Pipeline (declarative or freestyle) runs terraform init → plan → apply to deploy the cluster.

Jenkins uses AWS credentials to authenticate with your AWS account.

🔧 Prerequisites
Jenkins (self-hosted or EC2-based)

Terraform CLI installed on Jenkins

AWS CLI installed on Jenkins

Jenkins plugins:

Terraform Plugin

AWS Credentials Plugin

Git Plugin

AWS IAM user with permissions for EKS, EC2, IAM, VPC

📁 Directory Structure
css
Copy
Edit
eks-jenkins-deploy/
├── Jenkinsfile
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
🚀 Terraform Code for EKS
versions.tf
hcl
Copy
Edit
terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}
variables.tf
hcl
Copy
Edit
variable "region" {
  default = "us-west-2"
}

variable "cluster_name" {
  default = "jenkins-eks-cluster"
}

variable "node_group_name" {
  default = "jenkins-node-group"
}

variable "desired_capacity" {
  default = 2
}

variable "min_capacity" {
  default = 1
}

variable "max_capacity" {
  default = 3
}
main.tf
h
Copy
Edit
data "aws_availability_zones" "available" {}

resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "eks_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = aws_subnet.eks_subnet[*].id
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = aws_subnet.eks_subnet[*].id

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_capacity
    min_size     = var.min_capacity
  }

  instance_types = ["t3.medium"]

  depends_on = [aws_iam_role_policy_attachment.eks_worker_node_policy]
}
outputs.tf
hcl
Copy
Edit
output "cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}
📜 Jenkinsfile
groovy
Copy
Edit
pipeline {
  agent any

  environment {
    AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    TF_IN_AUTOMATION      = "true"
  }

  stages {
    stage('Clone Repo') {
      steps {
        git 'https://github.com/your-org/eks-jenkins-deploy.git'
      }
    }

    stage('Terraform Init') {
      steps {
        sh 'terraform init'
      }
    }

    stage('Terraform Plan') {
      steps {
        sh 'terraform plan -out=tfplan'
      }
    }

    stage('Terraform Apply') {
      steps {
        sh 'terraform apply -auto-approve tfplan'
      }
    }
  }
}
🛠 Jenkins Setup
Install Tools: Terraform CLI and AWS CLI

Install Plugins:

AWS Credentials Plugin

Terraform Plugin

Git Plugin

Add AWS Credentials:

Jenkins → Manage Jenkins → Credentials → Add Credentials

Use the ID: aws-access-key-id, aws-secret-access-key

Create a Pipeline Job:

Choose Pipeline → Paste or pull the Jenkinsfile

✅ Result
After running the Jenkins job, you will have:

A fully deployed Amazon EKS cluster

Nodes running in public subnets

Output with the EKS endpoint and cluster name
