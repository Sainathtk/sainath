terraform {
  backend "s3" {
    bucket = "467.devops.candidate.exam"   # S3 bucket name
    key    = "sainath.kulsange"  # S3 key path for storing state
    region = "ap-south-1"  # AWS Region for the S3 bucket
  }
}
