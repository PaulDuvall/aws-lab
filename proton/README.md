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

NOTE: Publishing of a service template version currently fails with
the following error:

> The template schema is not valid: Missing property [pipelineInputType]

This is confusing since the service schema is just taken from the tutorial
and the documentation seems to confirm the schema's schema:
https://docs.aws.amazon.com/proton/latest/adminguide/svc-schema.html


### Cleaning up

```
proton/delete-everything.sh
```
