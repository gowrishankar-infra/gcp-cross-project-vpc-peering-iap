#!/usr/bin/env bash
set -euo pipefail

source scripts/00_set_context.sh >/dev/null 2>&1 || true

echo "==> Connectivity test: ping private IPs across peering using IAP SSH"

# Get private IPs (authoritative)
gcloud config set project "$PROJECT_A" >/dev/null
IP_A="$(gcloud compute instances describe "$VM_A" --zone="$ZONE" --format="get(networkInterfaces[0].networkIP)")"

gcloud config set project "$PROJECT_B" >/dev/null
IP_B="$(gcloud compute instances describe "$VM_B" --zone="$ZONE" --format="get(networkInterfaces[0].networkIP)")"

echo "Detected: $VM_A=$IP_A, $VM_B=$IP_B"

{
  echo "== Ping from $VM_A ($IP_A) -> $VM_B ($IP_B)"
  echo "Command: gcloud compute ssh $VM_A --zone=$ZONE --tunnel-through-iap --command \"ping -c 4 $IP_B\""
  gcloud config set project "$PROJECT_A" >/dev/null
  gcloud compute ssh "$VM_A" --zone="$ZONE" --tunnel-through-iap --command "ping -c 4 $IP_B"
  echo
  echo "== Ping from $VM_B ($IP_B) -> $VM_A ($IP_A)"
  echo "Command: gcloud compute ssh $VM_B --zone=$ZONE --tunnel-through-iap --command \"ping -c 4 $IP_A\""
  gcloud config set project "$PROJECT_B" >/dev/null
  gcloud compute ssh "$VM_B" --zone="$ZONE" --tunnel-through-iap --command "ping -c 4 $IP_A"
} | tee "outputs/ping_results.txt"

echo "==> Done."

