output "vpc_id" {
  description = "ID de la VPC"
  value       = aws_vpc.vpc.id
}

output "instance_public_ip" {
  description = "Dirección IP pública de la instancia EC2"
  value       = aws_instance.web_instance.public_ip
}

output "direct_ec2_access" {
  description = "URL directa para acceder a la app desplegada"
  value       = "http://${aws_instance.web_instance.public_ip}:8000"
}

output "ssh_command" {
  description = "Comando SSH para conectarse a la instancia"
  value       = "ssh -i tfg-key.pem ec2-user@${aws_instance.web_instance.public_ip}"
}
