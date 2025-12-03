#!/bin/bash
set -e

if [ -z "$AZP_URL" ]; then
  echo "AZP_URL not set"; exit 1
fi

if [ -z "$AZP_TOKEN" ]; then
  echo "AZP_TOKEN not set"; exit 1
fi

./config.sh \
  --unattended \
  --agent "${AZP_AGENT_NAME:-k8s-agent}" \
  --url "$AZP_URL" \
  --auth PAT \
  --token "$AZP_TOKEN" \
  --pool "${AZP_POOL:-Default}" 

cleanup() {
  echo "Cleaning up Azure DevOps agent..."
  ./config.sh remove --unattended --auth PAT --token "$AZP_TOKEN"
}

trap "cleanup" EXIT

./run.sh
