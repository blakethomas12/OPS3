variable "aws_region" {
  description = "Region to host in"
  type = string
  default = "us-east-1"
}

variable "project_name" {
  type = string
  default = "ops3"
}

variable "instance_type" {
  description = "ec2 instance to run"
  type = string
  default = "t3.small"
}

variable "key_name" {
  description = "keypair to use to ssh into ec2"
  type = string
  default = "cs312-keypair"
}

variable "allowed_ssh_cidr" {
  description = "ip ssh is allowed to connect from"
  type = string
  default = "0.0.0.0/0"
}

variable "private_key_path" {
  type = string
  default = "~/cs312-keypair.pem"
}

variable "profile_name" {
  type = string
  default = "LabInstanceProfile"
}

variable "ansible_playbook_path" {
  type = string
  default = "../ansible/playbook.yml"
}

variable "ssh_user" {
  type = string
  default = "ec2-user"
}

variable "backup_bucket" {
  type = string
  default = "ops3-backup-bucket"
}

variable "ecr_repo_url" {
  type = string
  default = "211125686014.dkr.ecr.us-east-1.amazonaws.com/ops3/minecraft"
}

variable "image_tag" {
  type = string
  default = "v1.0.0"
}