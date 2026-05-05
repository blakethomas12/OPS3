output "instance_id" {
  value = aws_instance.minecraft.id
}

output "public_ip" {
  value = aws_instance.minecraft.public_ip
}

output "public_dns" {
  value = aws_instance.minecraft.public_dns
}

output "ssh_command" {
  value = "ssh -i ${var.private_key_path} ${var.ssh_user}@${aws_instance.minecraft.public_ip}"
}

output "minecraft_connect_address" {
  value = "${aws_instance.minecraft.public_ip}:25565"
}

output "nmap_commmand" {
  value = "nmap -sV -Pn -p T:25565 ${aws_instance.minecraft.public_ip}"
}