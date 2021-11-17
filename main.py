import os
import sys


def create_backend():
    environ = sys.argv[4]
    project = sys.argv[3]
    region = sys.argv[2]
    layer = sys.argv[5]
    layers_list = layer.split('_')[1:]
    body = f'''bucket = "{project}-{environ}-terraform-state"
key = "{environ}/{'-'.join(layers_list)}/terraform.tfstate"
session_name = "terraform"
dynamodb_table = "msk-dev-terraform-state-lock"
region = "{region}"
encrypt = true'''

    try:
        f = open(f"terraform/layers/{layer}/environments/{environ}/backend.generated.tfvars", "w")
        f.write(body)
        f.close()
    except FileNotFoundError:
        print('FileNotFoundError. Exiting.')
        sys.exit(1)

def main():
    task = sys.argv[1]

    if task == 'create-backend':
        create_backend()


if __name__ == '__main__':
    main()
