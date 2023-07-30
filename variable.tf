variable "ami_id" {
  type    = string
  default = "ami-0f34c5ae932e6f0e4"
}

variable "inst_type" {
  type    = string
  default = "t2.micro"
}

variable "inst_count" {
  default = 1
}
