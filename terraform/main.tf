
provider "aws" { 
 region = "us-west-2" 
} 
resource "aws_key_pair" "test" { 
 key_name = var.key_name 
 public_key = file("./demo.pub") 
} 
resource "aws_instance" "web" { 
 ami = var.ami 
 instance_type = var.instance_type 
 subnet_id = var.subnet_id[0]
 key_name = aws_key_pair.test.key_name 
 vpc_security_group_ids =[var.vpc_security_group_id]
 tags = { 
 Name = "StrapiServer"
 } 
 connection {
 type = "ssh" 
 user = "ubuntu" 
 private_key = file("./demo")  
 host = self.public_ip 
 timeout = "1m" 
 agent = false 
 } 
  provisioner "remote-exec" {
  inline = [
      "sudo apt-get update",
      "curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -",
      "sudo apt install -y nodejs",
      "sudo npm install -g yarn",
      "sudo apt-get install git -y",
      "sudo npm install -g pm2 ",
      #"sudo npm install -g strapi@latest -y ",
  ]
}
}

