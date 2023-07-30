resource "aws_instance" "demo-terraform" {
  ami           = var.ami_id
  instance_type = var.inst_type
  count         = var.inst_count
}
