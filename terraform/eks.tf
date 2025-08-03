# #eks cluster role
# resource "aws_iam_role" "eks_cluster_role" {
#   name = "eks-cluster-role"

#   assume_role_policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Action" : "sts:AssumeRole",
#         "Principal" : {
#           "Service" : "eks.amazonaws.com"
#         },
#         "Effect" : "Allow",
#         "Sid" : ""
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.eks_cluster_role.name
# }

# resource "aws_iam_role_policy_attachment" "eks_vpc_controller" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
#   role       = aws_iam_role.eks_cluster_role.name
# }

# #eks node group role
# resource "aws_iam_role" "eks_node_group_role" {
#   name = "eks-node-group-role"

#   assume_role_policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Action" : "sts:AssumeRole",
#         "Principal" : {
#           "Service" : "ec2.amazonaws.com"
#         },
#         "Effect" : "Allow",
#         "Sid" : ""
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "worker_node_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.eks_node_group_role.name
# }

# resource "aws_iam_role_policy_attachment" "container_registry_read_only" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.eks_node_group_role.name
# }

# resource "aws_iam_role_policy_attachment" "cni_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.eks_node_group_role.name
# }

# #eks cluster
# resource "aws_eks_cluster" "eks_cluster" {
#   name     = "eks-cluster"
#   role_arn = aws_iam_role.eks_cluster_role.arn

#   vpc_config {
#     subnet_ids = module.vpc.private_subnets
#   }
# }

# #eks node group
# resource "aws_eks_node_group" "eks_node_group" {
#   cluster_name  = aws_eks_cluster.eks_cluster.name
#   node_role_arn = aws_iam_role.eks_node_group_role.arn
#   subnet_ids    = module.vpc.private_subnets
#   scaling_config {
#     desired_size = 2
#     max_size     = 3
#     min_size     = 1
#   }
# }
