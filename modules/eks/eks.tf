resource "aws_eks_cluster" "CLUSTER" {
  name     = "GuyNode"
  role_arn = "${aws_iam_role.eks_cluster_role.arn}"
  vpc_config {
    subnet_ids = [
      "${var.subnetidAZ1}","${var.subnetidAZ2}"
    ]
  }
  depends_on = [
    "aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy",
    "aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy",
    "aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly",
  ]
}


resource "aws_eks_node_group" "nodes" {
  cluster_name    = "${aws_eks_cluster.CLUSTER.name}"
  node_group_name = "node_sping_boot"
  node_role_arn   = "${aws_iam_role.eks_nodes_role.arn}"
  subnet_ids      = [
      "${var.subnetidAZ1}","${var.subnetidAZ2}"
  ]
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
   # Type of capacity associated with the EKS Node Group.
  # Valid values: ON_DEMAND, SPOT
  capacity_type = "SPOT"

  # Disk size in GiB for worker nodes
  disk_size = 20

  # List of instance types associated with the EKS Node Group
   instance_types = ["t2.micro"]

# Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
# Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    "aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy",
    "aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy",
    "aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly",
  ]
}

output "eks_cluster_endpoint" {
  value = "${aws_eks_cluster.CLUSTER.endpoint}"
}

output "eks_cluster_certificat_authority" {
    value = "${aws_eks_cluster.CLUSTER.certificate_authority}"
}