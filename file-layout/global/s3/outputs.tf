output "s3_bucket_name" {
    description = "The ARN of the s3 bucket"
    value = aws_s3_bucket.terraform_state.arn
}

output "dynamodb_table_name" {
    description = "The name of the DynamoDb table"
    value = aws_dynamodb_table.terraform_locks.name
}