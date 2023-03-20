
variable "STAGE" {}

source "amazon-ebs" "debian" {
  ami_name      = "webapp-vm-image"
  instance_type = "t3.small"
  region        = "eu-west-3"
  source_ami    = "ami-04e905a52ec8010b2"
  ssh_username  = "admin"
  tags          = {
    Name        = "webapp-vm-image"
    APP         = "WEBAPP"
    STAGE       = var.STAGE
  }
}


build {
  sources = ["source.amazon-ebs.debian"]
  provisioner "ansible" {
    playbook_file = "./ansible/playbook.yml"
  }
}


