resource "aws_security_group" "jenkins_ec2_sg" {
  name        = "jenkins-ec2-sg"
  description = "Allow port 22, 8080 and 9100"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# Allow port 9100 to access node exporter for monitoring with prometheus
    ingress {      
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins" {
  ami                    = var.ami_id     # linux 2 AMI
  instance_type          = var.instance_type
  iam_instance_profile   = var.iam_instance_profile 
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.jenkins_ec2_sg.id]
  user_data              = file("scripts/jenkins-setup.sh")
  tags = {
    Name = "jenkins"
    Application = "jenkins"
  }
#-------------------------------------------------------------------------------------------------------

  # # best practices as per checkov scanner
  # monitoring    = true
  # ebs_optimized = true
  # root_block_device {
  #   encrypted = true
  # }

}

resource "aws_security_group" "sonarqube_ec2_sg" {
  name        = "sonarqube-ec2-sg"
  description = "Allow port 22 and 9000"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {    # For node exporter for monitoring
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "sonarqube" {
  ami                    = var.sonarqube_ami_id     # linux 2 AMI
  instance_type          = var.sonarqube_instance_type
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.sonarqube_ec2_sg.id]
  user_data              = file("scripts/sonarqube-setup.sh")
  tags = {
    Name = "sonarqube"
  }
#-------------------------------------------------------------------------------------------------------

  # # best practices as per checkov scanner
  # monitoring    = true
  # ebs_optimized = true
  # root_block_device {
  #   encrypted = true
  # }

}

resource "aws_security_group" "nexus_ec2_sg" {
  name        = "nexus-ec2-sg"
  description = "Allow port 22,8081 and 9100"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {    # For node exporter for monitoring
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Setting up Nexus Server
resource "aws_instance" "nexus" {
  ami                    = var.nexus_ami_id     # linux 2 AMI
  instance_type          = var.nexus_instance_type
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.nexus_ec2_sg.id]
  user_data              = file("scripts/nexus-setup.sh")
  tags = {
    Name = "nexus"
  }

  # # best practices as per checkov scanner
  # monitoring    = true
  # ebs_optimized = true
  # root_block_device {
  #   encrypted = true
  # }

}

#------------------------------------------------------------------------------------------------------

resource "aws_security_group" "my_instances_ec2_sg" {
  name        = "my_instances-ec2-sg"
  description = "Allow port 22, 8080 and 9100"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# Allow port 9100 to access node exporter for monitoring with prometheus
    ingress {      
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instances" {
  count         = length(var.instance_names)
  ami           = var.my_instances_ami_id
  key_name      = var.key_pair_name
  instance_type = var.my_instances_instance_type
  user_data              = file("scripts/deployment-setup.sh")
  vpc_security_group_ids = [aws_security_group.my_instances_ec2_sg.id]
  tags = {
    Name = var.instance_names[count.index]
    Environment = var.instance_names[count.index]
  }
  # Additional configuration...
}
#-----------------------------------------------------------------------------------------------------

resource "aws_security_group" "prometheus_ec2_sg" {
  name        = "prometheus-ec2-sg"
  description = "Allow port 22 and 9090"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "prometheus" {
  ami           = var.prometheus_ami_id
  key_name      = var.key_pair_name
  iam_instance_profile   = "prometheus-server-role" 
  instance_type = var.prometheus_instance_type
  user_data              = file("scripts/prometheus-setup.sh")
  vpc_security_group_ids = [aws_security_group.prometheus_ec2_sg.id]
  tags = {
    Name = "prometheus" 
   
  }
  # Additional configuration...
}

#------------------------------------------------------------------------------------------------------

resource "aws_security_group" "grafana_ec2_sg" {
  name        = "grafana-ec2-sg"
  description = "Allow port 22 and 3000"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "grafana" {
  ami           = var.grafana_ami_id  # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type AMI
  key_name      = var.key_pair_name
  instance_type = var.grafana_instance_type
  user_data              = file("scripts/grafana-setup.sh")
  vpc_security_group_ids = [aws_security_group.grafana_ec2_sg.id]
  tags = {
    Name = "grafana"
   
  }
  # Additional configuration...
}
