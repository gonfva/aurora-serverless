output "security_group" {
  value       = aws_security_group.cluster_sg.id
  description = "The security group associated with the cluster"
}

output "rw_endpoint" {
  value       = aws_rds_cluster.cluster.endpoint
  description = "The URL for the write endpoint in the cluster"
}

output "ro_endpoint" {
  value       = aws_rds_cluster.cluster.endpoint
  description = "The URL for the read endpoint in the cluster"
}

output "keys" {
  value       = random_password.passwords
  sensitive   = true
  description = "A map with the keys (we should use secret manager or SSM parameter store instead)"
}
