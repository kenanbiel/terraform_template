variable "client_name" {
  description = "This will represent *unique* name of the client."
}

variable "region" {
  description = "This will represent the geographic location where client's resources will be deployed."
}

variable "availability_zone" {
  type = "list"
  description = "This will be the isolated locations per region where client's resources will be deployed."
}

variable "cidr" {
  description = "This will be the IP allocation of the client."
}

variable "subnet" {
  type = "list"
  description = "This will be the subnet logical network subdivision of the CIDR."
}
