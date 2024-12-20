# Output the static website endpoint URL
output "s3_website_endpoint" {
    value = aws_s3_bucket.static_bucket.id
}