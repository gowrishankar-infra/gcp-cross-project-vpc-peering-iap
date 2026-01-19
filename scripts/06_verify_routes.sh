#!/usr/bin/env bash
set -euo pipefail

source scripts/00_set_context.sh >/dev/null 2>&1 || true

echo "==> Verify peering routes exist on both sides (SRE proof)"

# Project A: route to CIDR_B via peering
gcloud config set project "$PROJECT_A" >/dev/null
gcloud compute routes list \
  --filter="network:$VPC_A AND destRange=$CIDR_B" \
  --format="table(name,destRange,nextHopPeering,priority)" | tee "outputs/routes_project_a.txt"

# Project B: route to CIDR_A via peering
gcloud config set project "$PROJECT_B" >/dev/null
gcloud compute routes list \
  --filter="network:$VPC_B AND destRange=$CIDR_A" \
  --format="table(name,destRange,nextHopPeering,priority)" | tee "outputs/routes_project_b.txt"

echo "==> Done."

