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

# terraform {
#   backend "s3" {
#     bucket = "terraform-up-and-running-state-narayanan"
#     key = "global/s3/terraform.tfstate"
#     region = "us-east-2"
#     dynamodb_table = "terraform-up-and-running-locks"
#     encrypt = true
#   }
# }

output "s3_bucket_name" {
    description = "The ARN of the s3 bucket"
    value = aws_s3_bucket.terraform_state.arn
}

output "dynamodb_table_name" {
    description = "The name of the DynamoDb table"
    value = aws_dynamodb_table.terraform_locks.name
}