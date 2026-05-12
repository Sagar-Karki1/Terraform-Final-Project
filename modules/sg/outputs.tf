output "webserver_sg_id" {
  value = aws_security_group.webserver-sg.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion-sg.id
}

output "private_sg_id" {
  value = aws_security_group.private-sg.id
}

output "alb_sg_id" {
  value = aws_security_group.alb-sg.id
}