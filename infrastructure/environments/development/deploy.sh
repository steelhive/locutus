#! /bin/bash

set -e

terraform plan -out=./apply.tfplan \
    -target module.core \
    -target module.vpc \
    -target module.public_subnets \
    -target module.private_subnets

terraform apply ./apply.tfplan

terraform plan -out=./apply.tfplan

terraform apply ./apply.tfplan

rm ./apply.tfplan
