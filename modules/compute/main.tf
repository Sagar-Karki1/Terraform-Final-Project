#IAM role for EC2 to access S3
resource "aws_iam_role" "ec2_s3_access_role" {
  name = "${var.env}-EC2-S3-Access-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach S3 read-only policy to the role
resource "aws_iam_role_policy_attachment" "s3_read_only_attachment" {
  role       = aws_iam_role.ec2_s3_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

#Instance Profile for EC2 to use the IAM role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.env}-EC2-Instance-Profile"
  role = aws_iam_role.ec2_s3_access_role.name
}

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
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
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