#!/usr/bin/env bash
set -euo pipefail

AWS_REGION="us-east-2"
STATE_BUCKET="omari-terraform-state"
LOCK_TABLE="terraform-state-locks"

echo "Creating S3 bucket for Terraform state in ${AWS_REGION}..."

aws s3api create-bucket \
  --bucket "$STATE_BUCKET" \
  --region "$AWS_REGION" \
  --create-bucket-configuration LocationConstraint="$AWS_REGION"

echo "Enabling versioning on state bucket..."
aws s3api put-bucket-versioning \
  --bucket "$STATE_BUCKET" \
  --versioning-configuration Status=Enabled

echo "Enabling encryption on state bucket..."
aws s3api put-bucket-encryption \
  --bucket "$STATE_BUCKET" \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

echo "Blocking all public access on state bucket..."
aws s3api put-public-access-block \
  --bucket "$STATE_BUCKET" \
  --public-access-block-configuration '{
    "BlockPublicAcls": true,
    "IgnorePublicAcls": true,
    "BlockPublicPolicy": true,
    "RestrictPublicBuckets": true
  }'

echo "Creating DynamoDB table for Terraform state locking..."

aws dynamodb create-table \
  --table-name "$LOCK_TABLE" \
  --billing-mode PAY_PER_REQUEST \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --region "$AWS_REGION"

echo "Terraform backend bootstrap complete."
