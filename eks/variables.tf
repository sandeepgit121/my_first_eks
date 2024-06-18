variable "location" {
    default = "ap-south-1"
}

variable "os_name" {
    default = "ami-09ba48996007c8b50"
}

variable "key" {
    default = "eks"
}

variable "instance-type" {
    default = "t2.small"
}

variable "vpc-cidr" {
    default = "10.10.0.0/16"  
}

variable "subnet-1-cidr" {
    default = "10.10.1.0/24"
  
}
variable "subnet-2-cidr" {
    default = "10.10.2.0/24"
}
variable "subent-1_az" {
    default =  "ap-south-1a"  
}
variable "subent-2_az" {
    default =  "ap-south-1b"  
}



