#!/usr/bin/env bash
set -euo pipefail

source scripts/00_set_context.sh >/dev/null 2>&1 || true

echo "==> Create VPC Peering both directions (A->B and B->A)"

# A -> B
gcloud config set project "$PROJECT_A" >/dev/null
if gcloud compute networks peerings describe "$PEER_A_TO_B" --network="$VPC_A" >/dev/null 2>&1; then
  echo "OK: $PEER_A_TO_B already exists"
else
  gcloud compute networks peerings create "$PEER_A_TO_B" \
    --network="$VPC_A" \
    --peer-project="$PROJECT_B" \
    --peer-network="$VPC_B"
  echo "Created: $PEER_A_TO_B"
fi

# B -> A
gcloud config set project "$PROJECT_B" >/dev/null
if gcloud compute networks peerings describe "$PEER_B_TO_A" --network="$VPC_B" >/dev/null 2>&1; then
  echo "OK: $PEER_B_TO_A already exists"
else
  gcloud compute networks peerings create "$PEER_B_TO_A" \
    --network="$VPC_B" \
    --peer-project="$PROJECT_A" \
    --peer-network="$VPC_A"
  echo "Created: $PEER_B_TO_A"
fi

echo "==> Evidence: peering status"
gcloud config set project "$PROJECT_A" >/dev/null
gcloud compute networks peerings list --network="$VPC_A" | tee "outputs/peering_status_a.txt"

gcloud config set project "$PROJECT_B" >/dev/null
gcloud compute networks peerings list --network="$VPC_B" | tee "outputs/peering_status_b.txt"

echo "==> Done."

