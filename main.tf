terraform {
  required_version = ">= 0.13"
}

variable PUBLIC_KEY {
  type        = string
  default     = ""
  description = "public key for AWS"
}
variable AWS_DEFAULT_REGION {
  type        = string
  default     = ""
  description = "region"
}
variable AWS_ACCESS_KEY_ID {
  type        = string
  default     = ""
  description = "keyId for AWS"
}
variable AWS_SECRET_ACCESS_KEY {
  type        = string
  default     = ""
  description = "SecretKey for AWS "
}

provider "aws" {
    region = var.AWS_DEFAULT_REGION
    access_key = var.AWS_ACCESS_KEY_ID
    secret_key = var.AWS_SECRET_ACCESS_KEY
}
