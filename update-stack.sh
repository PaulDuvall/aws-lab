#!/usr/bin/env bash -e
envname=${1:-production}
stack_name=aws-lab-${envname}
set -x

aws cloudformation update-stack \
    --stack-name ${stack_name} \
    --template-body file://./vpc.yml \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameters \
        ParameterKey=EnvironmentName,ParameterValue=${envname}

{ set +x; } 2>/dev/null
echo "Track progress at https://console.aws.amazon.com/cloudformation"
aws cloudformation wait stack-update-complete --stack-name ${stack_name}
