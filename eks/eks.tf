// Create Subnet
resource "aws_subnet" "demo_subnet-1" {
  vpc_id     = aws_vpc.demo-vpc.id 
  cidr_block = var.subnet-1-cidr
  availability_zone = var.subent-1_az

  tags = {
    Name = "demo_subnet-1"
  }
}
// Create Subnet
resource "aws_subnet" "demo_subnet-2" {
  vpc_id     = aws_vpc.demo-vpc.id 
  cidr_block = var.subnet-2-cidr
  availability_zone = var.subent-2_az

  tags = {
    Name = "demo_subnet-2"
  }
}

// Create Internet Gateway

resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "demo-igw"
  }
}

resource "aws_route_table" "demo-rt" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }
  tags = {
    Name = "demo-rt"
  }
}

// associate subnet with route table 
resource "aws_route_table_association" "demo-rt_association-1" {
  subnet_id      = aws_subnet.demo_subnet-1.id 

  route_table_id = aws_route_table.demo-rt.id
}

resource "aws_route_table_association" "demo-rt_association-2" {
  subnet_id      = aws_subnet.demo_subnet-2.id 

  route_table_id = aws_route_table.demo-rt.id
}
// create a security group 

resource "aws_security_group" "demo-vpc-sg" {
  name        = "demo-vpc-sg"
 
  vpc_id      = aws_vpc.demo-vpc.id

  ingress {

    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
resource "aws_iam_role" "master" {
  name = "ed-eks-master"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
=======
  cluster_name                   = local.name
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
>>>>>>> 152d0a36cb419c2929add03a3c93b1fee92d5e72
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
<<<<<<< HEAD
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "x-ray" {
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
  role       = aws_iam_role.worker.name
}
resource "aws_iam_role_policy_attachment" "s3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "autoscaler" {
  policy_arn = aws_iam_policy.autoscaler.arn
  role       = aws_iam_role.worker.name
}

resource "aws_iam_instance_profile" "worker" {
  depends_on = [aws_iam_role.worker]
  name       = "ed-eks-worker-new-profile"
  role       = aws_iam_role.worker.name
}

###############################################################################################################
resource "aws_eks_cluster" "eks" {
  name = "ed-eks-01"
  role_arn = aws_iam_role.master.arn

  vpc_config {
    subnet_ids = [var.subnet_ids[0],var.subnet_ids[1]]
  }
  
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    #aws_subnet.pub_sub1,
    #aws_subnet.pub_sub2,
  ]

}
#################################################################################################################

resource "aws_eks_node_group" "backend" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "dev"
  node_role_arn   = aws_iam_role.worker.arn
  subnet_ids = [var.subnet_ids[0],var.subnet_ids[1]]
  capacity_type = "ON_DEMAND"
  disk_size = "20"
  instance_types = ["t2.small"]
  remote_access {
    ec2_ssh_key = "rtp-03"
    source_security_group_ids = [var.sg_ids]
  } 
  
  labels =  tomap({env = "dev"})
  
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
=======
>>>>>>> 152d0a36cb419c2929add03a3c93b1fee92d5e72
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["m5.large"]

    attach_cluster_primary_security_group = true
  }

  eks_managed_node_groups = {
    amc-cluster-wg = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"

      tags = {
        ExtraTag = "helloworld"
      }
    }
  }

  tags = local.tags
}
