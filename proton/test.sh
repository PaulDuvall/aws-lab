#/usr/bin/env

set -x
. proton/variables

if ! jq 1>/dev/null 2>&1; then
    # Install the jq
    sudo yum -y install jq
fi

account_id=`aws sts get-caller-identity|jq -r ".Account"`

echo ${account_id}
