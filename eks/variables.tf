variable "location" {
    default = "ap-south-1"
}

variable "os_name" {
    default = "ami-0e1d06225679bc1c5"
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

variable "subnet1-cidr" {
    default = "10.10.1.0/24"

variable "subnet2-cidr" {
    default = "10.10.2.0/24"

  
}
variable "subent1_az" {
    default =  "ap-south-1a"  
}
variable "subent2_az" {
    default =  "ap-south-1b"  
}
