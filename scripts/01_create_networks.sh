#!/usr/bin/env bash
set -euo pipefail

source scripts/00_set_context.sh >/dev/null 2>&1 || true

echo "==> [Project A] Using AUTO VPC: $VPC_A"
echo "     (In many labs, auto VPC exists by default; we verify.)"

gcloud config set project "$PROJECT_A" >/dev/null

# Verify VPC A exists
if gcloud compute networks describe "$VPC_A" >/dev/null 2>&1; then
  echo "OK: Network $VPC_A exists in $PROJECT_A"
else
  echo "ERROR: Network $VPC_A not found in $PROJECT_A."
  echo "If you intended a default auto network, ensure you created/renamed correctly."
  exit 1
fi

echo "==> [Project B] Create CUSTOM VPC + subnet"
gcloud config set project "$PROJECT_B" >/dev/null

# Create VPC_B if missing
if gcloud compute networks describe "$VPC_B" >/dev/null 2>&1; then
  echo "OK: Network $VPC_B already exists"
else
  gcloud compute networks create "$VPC_B" --subnet-mode=custom
  echo "Created: $VPC_B"
fi

# Create subnet-b if missing
if gcloud compute networks subnets describe "$SUBNET_B" --region="$REGION" >/dev/null 2>&1; then
  echo "OK: Subnet $SUBNET_B already exists in $REGION"
else
  gcloud compute networks subnets create "$SUBNET_B" \
    --network="$VPC_B" \
    --region="$REGION" \
    --range="$CIDR_B"
  echo "Created: $SUBNET_B ($CIDR_B)"
fi

echo "==> Evidence: list subnets"
gcloud config set project "$PROJECT_A" >/dev/null
gcloud compute networks subnets list \
  --filter="network:$VPC_A AND region:$REGION" \
  --format="table(name,region,network,ipCidrRange)" | tee "outputs/subnets_project_a.txt"

gcloud config set project "$PROJECT_B" >/dev/null
gcloud compute networks subnets list \
  --filter="network:$VPC_B AND region:$REGION" \
  --format="table(name,region,network,ipCidrRange)" | tee "outputs/subnets_project_b.txt"

echo "==> Done."

