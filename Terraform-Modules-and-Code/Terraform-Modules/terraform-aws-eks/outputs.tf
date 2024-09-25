output "eks_cluster_id" {
  value = aws_eks_cluster.eks_cluster.id
}
output "endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}
output "cluster_iam" {
  value = aws_iam_role.eks_master_role.name
}
output "node_group_iam" {
  value = aws_iam_role.eks_nodegroup_role.name
}
output "cluster_sg_id" {
  value = aws_security_group.eks_cluster_additional_sg.id
}
output "node_group_sg_id" {
  value = aws_security_group.node_group_sg.id
}