# This is a Cloudflare R2 bucket, not AWS
# Create a backend_cloudflare AWS credential with the Cloudflare creds
#
terraform {
  backend "s3" {
    bucket = "bf560c40aa5b1ffe-bucket-tfstate"
    key    = "vpn.tfstate"
    endpoints = {
      s3 = "https://f75ae3e72652c06327820fdcc5ef004e.r2.cloudflarestorage.com"
    }
    profile                     = "backend_cloudflare"
    region                      = "us-east-1"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
  }
}
