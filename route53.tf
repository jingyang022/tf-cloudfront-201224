data "aws_route53_zone" "sctp_zone" {
 name = "sctp-sandbox.com"
}

resource "aws_route53_record" "www" {
 zone_id = data.aws_route53_zone.sctp_zone.zone_id
 name = "yap201224" # Bucket prefix before sctp-sandbox.com
 type = "A"

 alias {
   name = aws_s3_bucket_website_configuration.website.website_domain
   zone_id = aws_s3_bucket.static_bucket.hosted_zone_id
   evaluate_target_health = true
 }
}