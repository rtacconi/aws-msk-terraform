import os
import sys
from pathlib import Path
import glob
import re

environ = 'dev'
project = 'msk'
region = 'eu-west-1'
layer = '15_security'

def create_backend():
    environ = sys.argv[4]
    project = sys.argv[3]
    region = sys.argv[2]
    layer = sys.argv[5]
    layers_list = layer.split('_')[1:]
    body = f'''bucket = "{project}-{environ}-terraform-state"
key = "{environ}/{'-'.join(layers_list)}/terraform.tfstate"
session_name = "{'-'.join(layers_list)}"
dynamodb_table = "msk-dev-terraform-state-lock"
region = "{region}"
encrypt = true'''

    path = f"terraform/layers/{layer}/environments/{environ}"
    if not os.path.isdir(path):
        os.makedirs(path)
        f = open(f"{path}/terraform.tfvars", "w+")
        f.write('')
        f.close()

    try:
        f = open(f"{path}/backend.generated.tfvars", "w+")
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



# [s for s in glob.glob(f"terraform/layers/*") if not re.match(r'^_', s.replace('terraform/layers/', ''))]
