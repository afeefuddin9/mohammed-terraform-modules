resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.cluster_name}-eks-cluster"
  role_arn = aws_iam_role.eks_master_role.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids              = var.cluster_subnets
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
    security_group_ids = [aws_security_group.eks_cluster_additional_sg.id]
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  tags = merge(
    {
      "Name" = format("%s", "${var.cluster_name}-eks-cluster")
    },
    var.default_tags,
    # var.vpc_tags,
  )

  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy
  ]
}

data "aws_eks_addon_version" "vpc-cni" {
  addon_name         = "vpc-cni"
  kubernetes_version = aws_eks_cluster.eks_cluster.version
  most_recent        = true
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  addon_name    = "vpc-cni"
  addon_version = data.aws_eks_addon_version.vpc-cni.version
  #resolve_conflicts = try("OVERWRITE")
  resolve_conflicts_on_create = try("OVERWRITE")
  preserve                    = try(true)
}

data "aws_eks_addon_version" "kube_proxy" {
  addon_name         = "kube-proxy"
  kubernetes_version = aws_eks_cluster.eks_cluster.version
  most_recent        = true
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  addon_name    = "kube-proxy"
  addon_version = data.aws_eks_addon_version.kube_proxy.version
  #resolve_conflicts = try("OVERWRITE")
  resolve_conflicts_on_create = try("OVERWRITE")
  preserve                    = try(true)
}

data "aws_eks_addon_version" "coredns" {
  addon_name = "coredns"
  # Need to allow both config routes - for managed and self-managed configs
  kubernetes_version = aws_eks_cluster.eks_cluster.version
  most_recent        = true
}

resource "aws_eks_addon" "coredns" {
  count         = var.enable_amazon_eks_coredns ? 1 : 0
  cluster_name  = aws_eks_cluster.eks_cluster.name
  addon_name    = "coredns"
  addon_version = data.aws_eks_addon_version.coredns.version
  #resolve_conflicts = try("OVERWRITE")
  resolve_conflicts_on_create = try("OVERWRITE")
  preserve                    = try(true)
  depends_on = [
    aws_eks_node_group.eks_node_group
  ]
}

