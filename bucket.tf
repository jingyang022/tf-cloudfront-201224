resource "aws_s3_bucket" "static_bucket" {
    bucket = "yap201224.sctp-sandbox.com"
    force_destroy = true
}


resource "aws_s3_bucket_public_access_block" "enable_public_access" {
    bucket = aws_s3_bucket.static_bucket.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "allow_public_access" {
    bucket = aws_s3_bucket.static_bucket.id
    
    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
		{
			"Sid": "PublicReadGetObject",
			"Principal": "*",
			"Effect": "Allow",
			"Action": [
				"s3:GetObject"
			],
			"Resource": ["arn:aws:s3:::yap201224.sctp-sandbox.com/*"]
		}
	]
    }
    )
}

resource "aws_s3_bucket_website_configuration" "website" {
    bucket = aws_s3_bucket.static_bucket.id

    index_document {
      suffix = "index.html"
    }

    error_document {
      key = "404.html"
    }

    #depends_on = [aws_s3_bucket_acl.bucket_acl]
}