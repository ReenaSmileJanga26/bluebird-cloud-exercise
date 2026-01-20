#!/usr/bin/env bash
set -euo pipefail

ACTION="${1:-apply}"
ENVIRONMENT="${ENVIRONMENT:-dev}"
TF_DIR="infrastructure"

require() { command -v "$1" >/dev/null 2>&1 || { echo "Missing dependency: $1" >&2; exit 1; }; }

require terraform
require aws
require curl

pushd "$TF_DIR" >/dev/null

terraform -version
aws sts get-caller-identity >/dev/null

terraform init -upgrade

if [ "$ACTION" = "plan" ]; then
  terraform plan
  popd >/dev/null
  exit 0
fi

if [ "$ACTION" = "apply" ]; then
  terraform apply -auto-approve
  APP_URL="$(terraform output -raw app_url)"
  HEALTH_URL="$(terraform output -raw health_url)"
  popd >/dev/null

  echo "App URL: ${APP_URL}"
  echo "Health:  ${HEALTH_URL}"
  ./scripts/healthcheck.sh "${HEALTH_URL}"
  exit 0
fi

if [ "$ACTION" = "destroy" ]; then
  terraform destroy -auto-approve
  popd >/dev/null
  exit 0
fi

echo "Usage: $0 [plan|apply|destroy]"
exit 1