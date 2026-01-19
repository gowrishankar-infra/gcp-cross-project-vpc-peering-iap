#!/usr/bin/env bash
set -euo pipefail

source scripts/00_set_context.sh >/dev/null 2>&1 || true

echo "==> Enable IAP API and allow SSH via IAP (avoid Cloud Shell IP changes)"

# Project A
gcloud config set project "$PROJECT_A" >/dev/null
gcloud services enable iap.googleapis.com

if gcloud compute firewall-rules describe "allow-iap-ssh-a" >/dev/null 2>&1; then
  echo "OK: allow-iap-ssh-a already exists"
else
  gcloud compute firewall-rules create "allow-iap-ssh-a" \
    --network="$VPC_A" \
    --direction=INGRESS \
    --allow=tcp:22 \
    --source-ranges="$IAP_RANGE"
  echo "Created: allow-iap-ssh-a"
fi

# Project B
gcloud config set project "$PROJECT_B" >/dev/null
gcloud services enable iap.googleapis.com

if gcloud compute firewall-rules describe "allow-iap-ssh-b" >/dev/null 2>&1; then
  echo "OK: allow-iap-ssh-b already exists"
else
  gcloud compute firewall-rules create "allow-iap-ssh-b" \
    --network="$VPC_B" \
    --direction=INGRESS \
    --allow=tcp:22 \
    --source-ranges="$IAP_RANGE"
  echo "Created: allow-iap-ssh-b"
fi

echo "==> Evidence: IAP firewall rules"
gcloud config set project "$PROJECT_A" >/dev/null
gcloud compute firewall-rules describe "allow-iap-ssh-a" \
  --format="yaml(name,network,sourceRanges,allowed)" | tee "outputs/iap_firewall_a.yaml"

gcloud config set project "$PROJECT_B" >/dev/null
gcloud compute firewall-rules describe "allow-iap-ssh-b" \
  --format="yaml(name,network,sourceRanges,allowed)" | tee "outputs/iap_firewall_b.yaml"

echo "==> Done."
echo "NOTE: If you still can't IAP SSH later, enable OS Login/IAM roles as needed (rare in basic labs)."

