This follows the example steps documented in
https://github.com/aws-samples/aws-proton-sample-templates

All templates and code examples are taken from there. Please
refer to that repo's LICENSE file for more information.

### Quick Start

```
proton/create-prerequisites.sh
proton/create-environment-template.sh
proton/create-service-template.sh
```

## Create Proton Environment

TBD

```
git clone https://github.com/aws-samples/aws-proton-sample-templates

cd aws-proton-sample-templates/loadbalanced-fargate-svc

aws proton-preview create-environment \
  --region us-west-2 \
  --environment-name "Beta" \
  --environment-template-arn arn:aws:proton:us-west-2:${account_id}:environment-template/public-vpc \
  --template-major-version-id 1 \
  --proton-service-role-arn arn:aws:iam::${account_id}:role/ProtonServiceRole \
  --spec file://specs/env-spec.yaml
  
aws proton-preview wait environment-deployment-complete \
  --region us-west-2 \
  --environment-name "Beta"

```

### Configure Roles

```

aws proton-preview update-account-roles \
  --region us-west-2 \
  --account-role-details "pipelineServiceRoleArn=arn:aws:iam::${account_id}:role/ProtonServiceRole"
```

### Create Proton Service

[Connection](https://us-west-2.console.aws.amazon.com/codesuite/settings/connections?region=us-west-2)

```
aws proton-preview create-service \
  --region us-west-2 \
  --service-name "front-end" \
  --repository-connection-arn arn:aws:codestar-connections:us-west-2:${account_id}:connection/<your-codestar-connection-id> \
  --repository-id "<your-source-repo-account>/<your-repository-name>" \
  --branch "main" \
  --template-major-version-id 1 \
  --service-template-arn arn:aws:proton:us-west-2:${account_id}:service-template/lb-fargate-service \
  --spec file://specs/svc-spec.yaml
  
aws proton-preview wait service-creation-complete \
  --region us-west-2 \
  --service-name "front-end"

```

Once the service is created, retrieve the CodePipeline pipeline console URL and the CRUD API endpoint URL for your service.

```
aws proton-preview get-service \
  --region us-west-2 \
  --service-name "front-end" \
  --query "service.pipeline.outputs" \
  --output text

aws proton-preview get-service-instance \
  --region us-west-2 \
  --service-name "front-end" \
  --service-instance-name "frontend-dev" \
  --query "serviceInstance.outputs" \
  --output text

```

### Cleaning up

```
proton/delete-everything.sh
```
