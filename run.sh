!#/bin/bash
if [ $# -ne 2 ]; then
  echo "$0 env(dev|prod) action(apply|destroy)"
  exit 1
fi
git pull
rm -rf .terraform
terraform init -backend-config=env-${1}/state.tfvars
terraform apply -var-file=env-${1}/main.tfvars -autoapprove
