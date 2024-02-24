variable "ami" {
    description = "ami for instance creation"
}

variable "instance_type" {
    description = "instance type for instance creation"
}

module "ec2_instance" {
  source = "./module/ec2_instance"
  ami = var.ami
  instance_type = var.instance_type
}