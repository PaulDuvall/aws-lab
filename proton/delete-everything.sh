#!/usr/bin/env bash
. proton/variables

set -x

if ! jq 1>/dev/null 2>&1; then
    # Install the jq
    sudo yum -y install jq
fi

account_id=`aws sts get-caller-identity|jq -r ".Account"`

s3_bucket=$(get_s3_bucket)

aws proton-preview delete-service-template-minor-version \
  --region ${region} \
  --template-name ${service_template_name} \
  --major-version-id 1 \
  --minor-version-id 0

aws proton-preview delete-service-template-major-version \
  --region ${region} \
  --template-name ${service_template_name} \
  --major-version-id 1

aws proton-preview delete-service-template \
  --region "${region}" \
  --template-name "${service_template_name}" \

aws s3 rm s3://${s3_bucket}/${service_template_arch} --region ${region}

aws proton-preview delete-environment-template-minor-version \
  --region ${region} \
  --template-name ${environment_template_name} \
  --major-version-id 1 \
  --minor-version-id 0

aws proton-preview delete-environment-template-major-version \
  --region ${region} \
  --template-name ${environment_template_name} \
  --major-version-id 1

aws proton-preview delete-environment-template \
  --region "${region}" \
  --template-name "${environment_template_name}" \

aws s3 rm s3://${s3_bucket}/${environment_template_arch} --region ${region}

aws cloudformation delete-stack \
    --stack-name ${stack_name} \
    --region ${region}

{ set +x; } 2>/dev/null
echo "Track progress at https://${region}.console.aws.amazon.com/cloudformation"
set -x

aws cloudformation wait stack-delete-complete \
    --stack-name ${stack_name} \
    --region ${region}

aws iam delete-role --role-name ProtonServiceRole
    
aws proton-preview delete-account-roles --region ${region}

aws s3api list-buckets --query 'Buckets[?starts_with(Name, `awsproton-front-end-`) == `true`].[Name]' --output text | xargs -I {} aws s3 rb s3://{} --force