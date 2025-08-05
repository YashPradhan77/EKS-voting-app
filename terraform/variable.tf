variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
  default     = "voting-cluster"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "desired_capacity" {
  default     = 2
  description = "Number of worker nodes"
}

variable "instance_type" {
  default     = "t3.medium"
  description = "EC2 instance type for worker nodes"
}
