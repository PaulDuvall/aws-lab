#!/usr/bin/env bash -e
. proton/variables

set -x
aws proton-preview delete-environment-template-minor-version \
  --region ${region} \
  --template-name ${template_name} \
  --major-version-id 1 \
  --minor-version-id 0

aws proton-preview delete-environment-template-major-version \
  --region ${region} \
  --template-name ${template_name} \
  --major-version-id 1

aws proton-preview delete-environment-template \
  --region "${region}" \
  --template-name "${template_name}" \

s3_bucket=$(get_s3_bucket)
aws s3 rm s3://${s3_bucket}/${template_arch} --region ${region}

aws cloudformation delete-stack \
    --stack-name ${stack_name} \
    --region ${region}

{ set +x; } 2>/dev/null
echo "Track progress at https://${region}.console.aws.amazon.com/cloudformation"
set -x

aws cloudformation wait stack-delete-complete \
    --stack-name ${stack_name} \
    --region ${region}
