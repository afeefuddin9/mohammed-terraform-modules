resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-eks-${var.ng_name}"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = var.ng_subnets
  #autoscaling_groups = var.autoscaling_groups
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
  
  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }
  # Desired max percentage of unavailable worker nodes during node group update.
  update_config {
    max_unavailable = 1
    #max_unavailable_percentage = 50    # ANY ONE TO USE
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEc2SSM,
    aws_launch_template.launch_template
  ]
  tags = merge(
    {
      "Name" = "${var.cluster_name}-eks-${var.ng_name}"
    },
    var.default_tags,
  )
}

#Launch Template
resource "aws_launch_template" "launch_template" {
  name_prefix = "${var.cluster_name}-eks-${var.ng_name}-launch-template"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 20
      encrypted             = true
      delete_on_termination = true
      volume_type           = "gp3"
    }
  }

  update_default_version = true
  ebs_optimized          = false
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.eks_cluster_additional_sg.id, aws_security_group.node_group_sg.id]
    delete_on_termination       = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "${var.cluster_name}-eks-${var.ng_name}-ec2"
      Billing = var.BillingTag
      Owner   = var.OwnerTag
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name    = "${var.cluster_name}-eks-${var.ng_name}-ec2-volume"
      Billing = var.BillingTag
      Owner   = var.OwnerTag
    }
  }
  #user_data                 = var.userDataDetails
  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -o xtrace
    /etc/eks/bootstrap.sh "${var.cluster_name}-eks-cluster"
    # Additional user data commands...
  EOF
  )
  depends_on = [
    aws_security_group.node_group_sg,
    aws_security_group.eks_cluster_additional_sg
  ]
}




