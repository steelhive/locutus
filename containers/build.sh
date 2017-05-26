#! /bin/bash

export DIR=$(pwd)

function build () {
    local dir=$1
    cd $dir
    make clean
    make build
    make push
    cd $DIR
}


build core/base
build core/exec
build core/svc
build util/aws
