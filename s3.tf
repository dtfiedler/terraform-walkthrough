resource "aws_s3_bucket" "dylans_bucket" {
  bucket_prefix = "dylans-test-bucket"

  tags = {
    Name        = "AR.IO"
    Environment = "dev"
  }
}

resource "aws_s3_object" "dylans_object" {
  bucket = aws_s3_bucket.dylans_bucket.id # --> Can someone tell me where to find this?
  key    = "dylans_fun_object.txt"
  source = "./test_file.txt"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("./test_file.txt")
  // Added later, ignore to start
  depends_on = [
    aws_s3_bucket_versioning.dylans_bucket_versioning
  ]
}

resource "aws_s3_bucket_acl" "dylans_bucket_acl" {
  bucket = aws_s3_bucket.dylans_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "dylans_bucket_versioning" {
  bucket = aws_s3_bucket.dylans_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}