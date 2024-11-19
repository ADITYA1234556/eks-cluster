module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "my-cluster"
  cluster_version = "1.31"

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id                   = "vpc-04c99ef201256c70f"
  subnet_ids               = ["subnet-06d63f443b5cec3af", "subnet-07fde5cc5ffb01580", "subnet-01e9eb9a0384143dd"]
  control_plane_subnet_ids = ["subnet-0a9a06f6091ddf1c2", "subnet-04abd9417c325302a", "subnet-09faee3faf5c288d3"]

  # Enable public access to the API server endpoint
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false

  # EKS Managed Node Group(s) with default configurations
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large", "t3.medium"]
    key_name       = "PERSONALACCOUNT" # Specify your key pair here
  }

  eks_managed_node_groups = {
    one = {
      ami_type       = "AL2_x86_64"
      instance_types = ["t3.medium"]
      key_name       = "PERSONALACCOUNT" # Alternatively, specify the key pair for each group

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
    two = {
      ami_type       = "AL2_x86_64"
      instance_types = ["t3.medium"]
      key_name       = "PERSONALACCOUNT" # Alternatively, specify the key pair for each group

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }

  enable_cluster_creator_admin_permissions = true

  access_entries = {
    example = {
      principal_arn = "arn:aws:iam::866934333672:role/ADIEC2S3FULLACCESS"

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }
      }
    }
  }

  tags = {
    Environment = "development"
    Terraform   = "true"
    Name = "EKS"
  }
}