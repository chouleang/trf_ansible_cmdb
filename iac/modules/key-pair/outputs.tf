output "key_name" {
  description = "Key pair name"
  value       = aws_key_pair.this.key_name
}

output "private_key_pem" {
  description = "Private key in PEM format"
  value       = tls_private_key.this.private_key_pem
  sensitive   = true
}

output "public_key_openssh" {
  description = "Public key"
  value       = tls_private_key.this.public_key_openssh
}