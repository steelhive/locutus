#! /bin/bash

set -e

terraform plan -destroy -out=./destroy.tfplan

terraform apply ./destroy.tfplan

rm ./destroy.tfplan
