variable "vpc_cidr_block" {
  description = "value of the cidr block for vpc"
}

variable "subnet_cidr_block" {
  description = "value of the cidr blok for subnet"
  type        = list(string)
}

variable "ami" {
  description = "ami value for instance creation"
}

variable "instancetype" {
  description = "instance type"
}