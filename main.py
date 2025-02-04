import os
import sys
from pathlib import Path
import glob
import re
import boto3

environ = "dev"
project = "msk"
region = "eu-west-1"
layer = "15_security"


def create_backend():
    environ = sys.argv[4]
    project = sys.argv[3]
    region = sys.argv[2]
    layer = sys.argv[5]
    layers_list = layer.split("_")[1:]
    body = f"""bucket = "{project}-{environ}-terraform-state"
key = "{environ}/{'-'.join(layers_list)}/terraform.tfstate"
session_name = "{'-'.join(layers_list)}"
dynamodb_table = "msk-dev-terraform-state-lock"
region = "{region}"
encrypt = true"""

    path = f"terraform/layers/{layer}/environments/{environ}"
    if not os.path.isdir(path):
        os.makedirs(path)
        f = open(f"{path}/terraform.tfvars", "w+")
        f.write(
            f'''environment = "{environ}"
project = "{project}"'''
        )
        f.close()

    f = open(f"{path}/backend.generated.tfvars", "w+")
    f.write(body)
    f.close()

    path = f"terraform/layers/{layer}/terraform.tf"
    f = open(path, "a")
    f.write(
        f"""terraform {{
  required_version = "~> 1.0.6"
  backend "s3" {{}}
}}

provider "aws" {{
  region = "{region}"
}}"""
    )
    f.close()

    # Add this to variables.tf
    # variable environment {
    #   type        = string
    #   description = "The name of the environment"
    # }
    #
    # variable project {
    #   type        = string
    #   description = "The name of the project"
    # }
    empty_files = [
        f"terraform/layers/{layer}/main.tf",
        f"terraform/layers/{layer}/variables.tf",
        f"terraform/layers/{layer}/outputs.tf",
    ]
    for file in empty_files:
        f = open(file, "a")
        f.write("")
        f.close()


# def create_bucket()
client = boto3.client('s3')
bucket_name = 'riccardotacconitesting12345'
client.create_bucket(Bucket=bucket_name)
import boto3
client = boto3.client('s3')
response = client.put_bucket_encryption(
    Bucket= bucket_name,
    ContentMD5='string',
    ServerSideEncryptionConfiguration={
        'Rules': [{'ApplyServerSideEncryptionByDefault': {'SSEAlgorithm': 'AES256'}},]
    }
)



def main():
    task = sys.argv[1]

    if task == "create-layer":
        create_backend()


if __name__ == "__main__":
    main()
