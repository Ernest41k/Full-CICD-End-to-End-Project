module "ec2" {
  source = "./ec2"
  key_pair_name = var.key_pair_name
  ami_id = var.ami_id
  nexus_ami_id = var.nexus_ami_id
  my_instances_instance_type = var.my_instances_type
  instance_names = var.instance_names
  my_instances_ami_id = var.my_instances_ami_id
  nexus_instance_type = var.nexus_instance_type
  sonarqube_ami_id = var.sonarqube_ami_id
  instance_type = var.instance_type
  sonarqube_instance_type = var.sonarqube_instance_type
  prometheus_ami_id = var.prometheus_ami_id
  prometheus_instance_type = var.prometheus_instance_type
  grafana_ami_id = var.grafana_ami_id
  grafana_instance_type = var.grafana_instance_type
  iam_instance_profile = var.iam_instance_profile
}
