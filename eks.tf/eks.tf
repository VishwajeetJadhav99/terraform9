provider "aws" {
  region  = "ap-south-1"
  profile = "configs"
}

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Get subnet from Availability Zone ap-south-1a
data "aws_subnet" "subnet_a" {
  filter {
    name   = "availability-zone"
    values = ["ap-south-1a"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Get subnet from Availability Zone ap-south-1b
data "aws_subnet" "subnet_b" {
  filter {
    name   = "availability-zone"
    values = ["ap-south-1b"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


# --------------------------------------------------
# EKS CLUSTER IAM ROLE
# --------------------------------------------------

resource "aws_iam_role" "eks_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}


# Attach EKS Cluster Policy
resource "aws_iam_role_policy_attachment" "eks_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}


# --------------------------------------------------
# EKS CLUSTER
# --------------------------------------------------

resource "aws_eks_cluster" "eks" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [
      data.aws_subnet.subnet_a.id,
      data.aws_subnet.subnet_b.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_policy_attachment
  ]
}


# --------------------------------------------------
# EKS NODE GROUP IAM ROLE
# --------------------------------------------------

resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}


# Worker Node Policy
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}


# CNI Policy
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}


# ECR Read Only Policy
resource "aws_iam_role_policy_attachment" "eks_ec2_container_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}


# --------------------------------------------------
# EKS NODE GROUP
# --------------------------------------------------

resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn

  subnet_ids = [
    data.aws_subnet.subnet_a.id,
    data.aws_subnet.subnet_b.id
  ]

  instance_types = ["t3.micro"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ec2_container_registry_policy
  ]
}


# --------------------------------------------------
# OUTPUTS
# --------------------------------------------------

output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "node_group_name" {
  value = aws_eks_node_group.eks_nodes.node_group_name
}