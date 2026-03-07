resource "tls_private_key" "webserver-kp" {
  algorithm = "RSA"
  rsa_bits  = 4096
  
}

resource "aws_key_pair" "key-pair" {
  key_name   = var.keypair_name
  public_key = tls_private_key.webserver-kp.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.webserver-kp.private_key_pem
  filename = "${path.root}/webserver-kp.pem"
  file_permission = "0400"
  
}

resource "aws_instance" "public_instances" {
  count = 4
  subnet_id = var.public_subnet_ids[count.index]
  vpc_security_group_ids = count.index == 1 ? [var.webserver_sg_id, var.bastion_sg_id] : [var.webserver_sg_id]
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.key-pair.key_name
  associate_public_ip_address = true
  tags = {
    Name = "${var.env}-WebServer-${count.index + 1}"  
  }
}

resource "aws_instance" "private_instances" {
  vpc_security_group_ids = [var.private_sg_id]
  subnet_id = var.private_subnet_ids[0]
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.key-pair.key_name
  associate_public_ip_address = false
  tags = {
    Name = "${var.env}-WebServer-5"  
  }
}

resource "aws_instance" "private-vm" {
  subnet_id = var.private_subnet_ids[1]
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.key-pair.key_name
  associate_public_ip_address = false
  vpc_security_group_ids = [var.private_sg_id]
  tags = {
    Name = "${var.env}-PrivateVM"  
  }
  
}