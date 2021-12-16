provider "aws" {
    region = "us-east-2"
}

#Create S3 bucket with lifecyle prevent destroy, versioning enabled, sse configured with AES256

resource "aws_s3_bucket" "terraform_state" {
    bucket = "terraform-up-and-running-state-narayanan"

    # lifecycle {
    #     prevent_destroy = true
    # }

    versioning {
        enabled = true
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }

    force_destroy = true #Allows to delete the bucket even if it contains objects in it.
}

resource "aws_dynamodb_table" "terraform_locks" {
    name = "terraform-up-and-running-locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}

# The below config has been commented to move the terraform state from s3 to local 

# terraform {
#   backend "s3" {
#     bucket = "terraform-up-and-running-state-narayanan"
#     key = "global/s3/terraform.tfstate"
#     region = "us-east-2"
#     dynamodb_table = "terraform-up-and-running-locks"
#     encrypt = true
#   }
# }

