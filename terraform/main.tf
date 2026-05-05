provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project = var.project_name
      ManagedBy = "Terraform"
      Assignment = "OPS3"
    }
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "al2023" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_security_group" "minecraft" {
  name = "${var.project_name}-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    from_port = 25565
    to_port = 25565
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "minecraft" {
  ami = data.aws_ami.al2023.id
  instance_type = var.instance_type
  subnet_id = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.minecraft.id]
  key_name = var.key_name
  iam_instance_profile = var.profile_name
  associate_public_ip_address = true

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted = false
  }

  user_data = <<-EOF
    #!/bin/bash
    set -e
    dnf install -y python3
  EOF

  lifecycle {
    ignore_changes = [user_data]
  }
}

# resource "null_resource" "ansible_provision" {
#   triggers = {
#     instance_id = aws_instance.minecraft.id
#   }

#   provisioner "local-exec" {
#     command = <<-EOT
#         echo "Waiting for SSH on ${aws_instance.minecraft.public_ip}..."
#         for i in $(seq 1 30); do
#             nc -z ${aws_instance.minecraft.public_ip} 22 && break
#             sleep 5
#         done
#         sleep 10

#         ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
#         -i '${aws_instance.minecraft.public_ip},'\
#         -u ${var.ssh_user} \
#         --private-key ${var.private_key_path} \
#          --extra-vars "s3_backup_bucket=${var.backup_bucket}" \
#         --extra-vars "ecr_repository_url=${var.ecr_repo_url}" \
#         --extra-vars "minecraft_image_tag=${var.image_tag}" \
#         --extra-vars "aws_region=${var.aws_region}" \
#         ${var.ansible_playbook_path}
#     EOT
#   }
#   depends_on = [aws_instance.minecraft]
# }