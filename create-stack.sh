#!/usr/bin/env bash -e
envname=${1:-prod}
stack_name=lab-${envname}
set -x

aws cloudformation create-stack \
    --stack-name ${stack_name} \
    --template-body file://./vpc.yml \
    --capabilities CAPABILITY_NAMED_IAM

{ set +x; } 2>/dev/null
echo "Track progress at https://console.aws.amazon.com/cloudformation"
aws cloudformation wait stack-create-complete --stack-name ${stack_name}
