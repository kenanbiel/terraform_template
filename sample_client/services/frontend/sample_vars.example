variable "region" {
  default = "ap-southeast-1"
}

variable "client_name" {
  description = "This will represent *unique* name of the client."
  default = "sample_client"
}

variable "asg_max_size" {
  description = "This will be the maximum size of the auto-scaling group."
  default = 2
}

variable "asg_min_size" {
  description = "This will be the minimum size of the auto-scaling group."
  default = 2
}

variable "image_id" {
  description = "This will be the Linux AMI to be used (varies per region)."
  default = "ami-25c00c46"
}

variable "instance_type" {
  description = "This will be type of resource to be used (varies per region)."
  default = "t2.micro"
}

variable "keyname" {
  description = "This will be the default ssh key to be installed on each of the servers"
  default = "default.id_rsa.pub"
}

variable "ssl_certificate_arn" {
  description = "This is the ARN of the SSL Certificate generated for the ELB."
  default = "<arn>"
}
