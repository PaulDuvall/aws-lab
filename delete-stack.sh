#!/usr/bin/env bash -e
envname=${1:-prod}
stack_name=lab-${envname}
set -x
aws cloudformation delete-stack --stack-name ${stack_name}
{ set +x; } 2>/dev/null
echo "Track progress at https://console.aws.amazon.com/cloudformation"
aws cloudformation wait stack-delete-complete --stack-name ${stack_name}
