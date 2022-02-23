resource "aws_s3_bucket" "web-bucket" {
  bucket = "random-web-bucket-name-example"
  tags = {
    Name        = "random-web-bucket-name-example"
  }
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.web-bucket.id
  acl    = "private"
}