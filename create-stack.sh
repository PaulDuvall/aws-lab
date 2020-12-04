#!/usr/bin/env bash
aws cloudformation create-stack \
    --stack-name aws-lab \
    --template-body file://./vpc.yml
