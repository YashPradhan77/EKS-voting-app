*** App Deployment on EKS ***

1. Create the underlying infrastructure (VPC, subnets, route tables, internet gateway, nat gateway, security groups).
    1. The EKS cluster is deployed in public subnets 
    2. Nodegroups are deployed in private subnets
    3. The EC2 nodes will reach EKS cluster kubeapi server through NAT Gateways present in the public subnet.
    4. AWS ALB is in the public subnet and all the user request will come through the ALB
2. Create EKS cluster role with policies - AmazonEKSClusterPolicy, AmazonEKSVPCResourceController.
3. Create EKS node group role with policies - AmazonEKSWorkerNodePolicy, AmazonEC2ContainerRegistryReadOnly, AmazonEKS_CNI_Policy.
4. Create the EKS cluster && Create the node group.

eksctl create cluster --name my-cluster --region us-east-1 --nodegroup-name standard-workers --node-type t3.medium --nodes 3 --nodes-min 1 --nodes-max 4 --managed

1. For Fargate 
    
    eksctl create fargateprofile \
    --cluster demo-cluster \
    --region us-east-1 \
    --name alb-sample-app \
    --namespace <namespace>
    
2. aws eks update-kubeconfig --region <region> --name <cluster name>
3. Apply the deployment.yaml kubectl config

### **Steps to load balance (internet facing) the above application**

1. Tag the public subnets with Tag name: kubernetes.io/role/elb; Tag value: 1.
2. Create IAM OIDC identity provider for your cluster. (Copy openid from cluster details)
    
    → eksctl utils associate-iam-oidc-provider --cluster $cluster_name --approve
    
3. Create load balancer controller policy and load balancer trust policy.
    1. aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document <file>
        1. policy = curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json
    2. eksctl create iamserviceaccount --cluster=<Cluster-name> --namespace=kube-system  --    name=aws-load-balancer-controller --role-name AmazonEKSLoadBalancerControllerRole 
    --attach-policy-arn=arn:aws:iam::<your-aws-account-id>:policy/AWSLoadBalancerControllerIAMPolicy --approve
4. Create load balancer controller role.
5. Create service-account.yml
6. Add eks-charts helm repository and update.
    
    → helm repo add eks https://aws.github.io/eks-charts
    
7. Install load balancer controller using helm.
    
    → helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=clusterName --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller
    
8. Apply the ingress.yaml kubectl config.