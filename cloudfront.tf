# Define an AWS CloudFront Distribution with S3 origin
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.static_bucket.bucket_domain_name
    origin_id   = aws_s3_bucket.static_bucket.bucket
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.my_oai.cloudfront_access_identity_path
    }
  }

  aliases = ["yap201224.sctp-sandbox.com"]

  default_cache_behavior {
    target_origin_id      = aws_s3_bucket.static_bucket.bucket
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods       = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods        = ["GET", "HEAD"]
    min_ttl               = 0
    default_ttl           = 3600
    max_ttl               = 86400

    forwarded_values {
      query_string = false
      
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    #cloudfront_default_certificate = true
    acm_certificate_arn      = aws_acm_certificate_validation.cert_validation.certificate_arn
    ssl_support_method       = "sni-only"
  }
  
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
}

#Creating AWS CloudFront origin access
resource "aws_cloudfront_origin_access_identity" "my_oai" {
  comment = "CloudFront OAI for S3 bucket"
}