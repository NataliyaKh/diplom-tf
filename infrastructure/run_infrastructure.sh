#!/bin/bash
set -e

SA_BUCKET_STATE="/home/vboxuser/git/diplom/diplom-tf/sa_bucket/terraform.tfstate"

ACCESS_KEY=$(jq -r '.outputs.access_key.value' "$SA_BUCKET_STATE")
SECRET_KEY=$(jq -r '.outputs.secret_key.value' "$SA_BUCKET_STATE")

if [[ -z "$ACCESS_KEY" || -z "$SECRET_KEY" ]]; then
  echo "Error: Could not read access keys from $SA_BUCKET_STATE"
  exit 1
fi

export AWS_ACCESS_KEY_ID="$ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="$SECRET_KEY"
echo "Exported AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY from sa_bucket outputs."

terraform init -reconfigure

terraform apply -auto-approve

