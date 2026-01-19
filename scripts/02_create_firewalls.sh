#!/usr/bin/env bash
set -euo pipefail

source scripts/00_set_context.sh >/dev/null 2>&1 || true

echo "==> Create ICMP (ping) rules for cross-project testing (CIDR-scoped)"

# Project A: allow ICMP from Project B CIDR
gcloud config set project "$PROJECT_A" >/dev/null
if gcloud compute firewall-rules describe "allow-icmp-from-b" >/dev/null 2>&1; then
  echo "OK: allow-icmp-from-b already exists"
else
  gcloud compute firewall-rules create "allow-icmp-from-b" \
    --network="$VPC_A" \
    --direction=INGRESS \
    --allow=icmp \
    --source-ranges="$CIDR_B"
  echo "Created: allow-icmp-from-b"
fi

# Project B: allow ICMP from Project A CIDR
gcloud config set project "$PROJECT_B" >/dev/null
if gcloud compute firewall-rules describe "allow-icmp-from-a" >/dev/null 2>&1; then
  echo "OK: allow-icmp-from-a already exists"
else
  gcloud compute firewall-rules create "allow-icmp-from-a" \
    --network="$VPC_B" \
    --direction=INGRESS \
    --allow=icmp \
    --source-ranges="$CIDR_A"
  echo "Created: allow-icmp-from-a"
fi

echo "==> Evidence: firewall rules snapshot"
gcloud config set project "$PROJECT_A" >/dev/null
gcloud compute firewall-rules list \
  --filter="network:$VPC_A" \
  --format="table(name,sourceRanges.list():label=SRC,allowed.list():label=ALLOW)" | tee "outputs/firewall_project_a.txt"

gcloud config set project "$PROJECT_B" >/dev/null
gcloud compute firewall-rules list \
  --filter="network:$VPC_B" \
  --format="table(name,sourceRanges.list():label=SRC,allowed.list():label=ALLOW)" | tee "outputs/firewall_project_b.txt"

echo "==> Done."

