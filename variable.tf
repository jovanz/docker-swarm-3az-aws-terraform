##################################################################################
# VARIABLES
##################################################################################
variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/16"
}

variable "namespace" {
  default = "swarm"
}

variable "aws_region" {
  description = "AWS region on which we will setup the swarm cluster"
  default     = "eu-central-1"
}

variable "ami" {
  description = "Amazon Linux AMI, Ubuntu Server 18.04 LTS"
  default     = "ami-0b1deee75235aa4bb"
}

variable "instance_type" {
  description = "Instance type"
  default     = "t2.micro"
}

variable "key_path" {
  description = "SSH Public Key path"
  default     = "~/.ssh/id_rsa.pub"
}
