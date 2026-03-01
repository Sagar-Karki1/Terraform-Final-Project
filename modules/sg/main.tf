resource "aws_security_group" "webserver-sg" {
  name        = "${var.env}-WebServer-SG"
  description = "Security group for web servers"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.webserver-sg.id
  ip_protocol = "tcp"
  from_port        = 80
  to_port          = 80
  cidr_ipv4      = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.webserver-sg.id
  ip_protocol = "tcp"
  from_port        = 22
  to_port          = 22
  cidr_ipv4      = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "webserver-egress" {
  security_group_id = aws_security_group.webserver-sg.id
  ip_protocol = "-1"
  cidr_ipv4      = "0.0.0.0/0"
  
}

resource "aws_security_group" "bastion-sg" {
  name        = "${var.env}-Bastion-SG"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id
  
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_bastion" {
  security_group_id = aws_security_group.bastion-sg.id
  ip_protocol = "tcp"
  from_port        = 22
  to_port          = 22
  cidr_ipv4      = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "bastion_to_private" {
    count = length(var.private_subnet_cidrs)
  security_group_id = aws_security_group.bastion-sg.id
  ip_protocol = "tcp"
  from_port        = 22
  to_port          = 22
  cidr_ipv4      = var.private_subnet_cidrs[count.index]
}

resource "aws_vpc_security_group_egress_rule" "allow-ssh-egress" {
  security_group_id = aws_security_group.bastion-sg.id
  ip_protocol = "tcp"
  from_port        = 22
  to_port          = 22
  cidr_ipv4      = "0.0.0.0/0"
  
}

resource "aws_security_group" "private-sg" {
  name        = "${var.env}-Private-SG"
  description = "Security group for private instances"
  vpc_id      = var.vpc_id
  
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_private" {
  security_group_id = aws_security_group.private-sg.id
  ip_protocol = "tcp"
  from_port        = 22
  to_port          = 22
  referenced_security_group_id = aws_security_group.bastion-sg.id
  
}

resource "aws_vpc_security_group_egress_rule" "private_egress" {
  security_group_id = aws_security_group.private-sg.id
  ip_protocol = "-1"
  cidr_ipv4      = "0.0.0.0/0"
  
}
