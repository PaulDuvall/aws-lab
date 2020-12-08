#/usr/bin/env -e

set -x
. proton/variables

# Create the environment template if it doesn't already exist
aws proton-preview get-environment-template \
    --template-name public-vpc \
    --region ${region} 1>/dev/null 2>$1 ||
aws proton-preview create-environment-template \
  --region "${region}" \
  --template-name "${template_name}" \
  --display-name "PublicVPC" \
  --description "VPC with Public Access and ECS Cluster"

# Create major version 1 of the template if it doesn't already exist
if [ 0 -eq $(aws proton-preview list-environment-template-major-versions --template-name public-vpc --region ${region} | jq -r '.templates | length') ]; then
    aws proton-preview create-environment-template-major-version \
      --region ${region} \
      --template-name "${template_name}" \
      --description "Version 1"
fi

# Prepare the environment template archive to be used for version 1.0
cd proton
if [ ! -f $template_arch ]; then
    tar -zcvf env-template.tar.gz environment/
fi
cd - >/dev/null

s3_bucket=$(get_s3_bucket)

# Upload the environment template archive if it doesn't already exist
if ! aws s3 ls --region ${region} s3://${s3_bucket}/${template_arch} >/dev/null; then
    aws s3 cp proton/${template_arch} s3://${s3_bucket}/${template_arch} --region ${region}
fi

# Create and publish minor version 1.0 if it doesn't already exist
if [ 0 -eq $(aws proton-preview --region ${region} list-environment-template-minor-versions --template-name ${template_name} | jq -r '.templates | length') ]; then
    aws proton-preview create-environment-template-minor-version \
      --region ${region} \
      --template-name "${template_name}" \
      --description "Version 1.0" \
      --major-version-id "1" \
      --source-s3-bucket ${s3_bucket} \
      --source-s3-key ${template_arch}

    aws proton-preview wait environment-template-registration-complete \
      --region ${region} \
      --template-name "${template_name}" \
      --major-version-id "1" \
      --minor-version-id "0"

    aws proton-preview update-environment-template-minor-version \
      --region ${region} \
      --template-name "${template_name}" \
      --major-version-id "1" \
      --minor-version-id "0" \
      --status "PUBLISHED"
fi

# major_ver_arn=$(aws proton-preview get-environment-template --template-name public-vpc --region ${region} | jq -r '.environmentTemplate.arn')
#
# aws proton-preview create-environment-template-major-version \
#   --region ${region} \
#   --template-name ${template_name} \
#   --description "Version 1" \
#   --compatible-environment-template-major-version-arns ${major_ver_arn}:1