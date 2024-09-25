output "output" {
    description = "Secret manager attributes"
    sensitive   = true
    value       = {
        secret  = aws_secretsmanager_secret.my-secret
        version = aws_secretsmanager_secret_version.my-secret
    }
}
