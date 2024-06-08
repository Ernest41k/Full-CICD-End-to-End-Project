
variable "key_pair_name" {
    type = string
    description = "name of key pair"
}

variable "ami_id" {
    type = string
    description = "ami id"
}

variable "instance_type" {
    type = string
}

# Sonarqube Server Variables
variable "sonarqube_ami_id" {
    type = string
}

variable "sonarqube_instance_type" {
    type = string
}


# Nexus Server Variables
variable "nexus_ami_id" {
    type = string
}
variable "nexus_instance_type" {
    type = string
}

# My Instances for prod, dev and stage variables
variable "my_instances_ami_id" {
    type = string
}
variable "my_instances_instance_type" {
    type = string
}
variable "instance_names" {
  type = list(string)
}


# Prometheus Server variables
variable "prometheus_ami_id" {
    type = string
}
variable "prometheus_instance_type" {
    type = string
}


# Grafana Server Variables
variable "grafana_ami_id" {
  type = string
}
variable "grafana_instance_type" {
  type = string
}

# IAM Instance Profile in Jenkins
variable "iam_instance_profile" {
    type = string
}
