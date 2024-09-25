
#Additional Security group for cluster
resource "aws_security_group" "eks_cluster_additional_sg" {
  name        = "${var.cluster_name}-additional-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.default_tags
}

resource "aws_security_group_rule" "cluster-ingress" {
  description              = "Allow workstation to communicate with the cluster API Server"
  from_port                = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.eks_cluster_additional_sg.id
  security_group_id        = aws_security_group.eks_cluster_additional_sg.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "Allow_node_group_sg" {
  description              = "Allowing ec2 security group"
  from_port                = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.node_group_sg.id
  security_group_id        = aws_security_group.eks_cluster_additional_sg.id
  to_port                  = 0
  type                     = "ingress"
}
#Launch Tempalte SG ==============
resource "aws_security_group" "node_group_sg" {
  name   = "${var.cluster_name}-eks-${var.ng_name}-sg"
  vpc_id = var.vpc_id

  # Egress allows Outbound traffic from the EKS cluster to the  Internet 

  egress { # Outbound Rule
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [
    aws_security_group.eks_cluster_additional_sg
  ]
  tags = var.default_tags
}

resource "aws_security_group_rule" "Allow_additional_cluster_sg" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.eks_cluster_additional_sg.id
  security_group_id        = aws_security_group.node_group_sg.id
  depends_on = [
    aws_security_group.eks_cluster_additional_sg
  ]
}
