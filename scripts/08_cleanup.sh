#!/usr/bin/env bash
set -euo pipefail

source scripts/00_set_context.sh >/dev/null 2>&1 || true

echo "==> CLEANUP (Lab 1)"
echo "This will delete:"
echo "- VMs: $VM_A (Project A), $VM_B (Project B)"
echo "- Peering: $PEER_A_TO_B, $PEER_B_TO_A"
echo "- Firewall rules created by this lab (icmp + iap ssh)"
echo "- VPC_B + subnet-b (Project B)"
echo
read -r -p "Type YES to continue: " CONFIRM
if [[ "$CONFIRM" != "YES" ]]; then
  echo "Aborted."
  exit 0
fi

# Delete VM-A
gcloud config set project "$PROJECT_A" >/dev/null
if gcloud compute instances describe "$VM_A" --zone="$ZONE" >/dev/null 2>&1; then
  gcloud compute instances delete "$VM_A" --zone="$ZONE" -q
  echo "Deleted: $VM_A"
else
  echo "Skip: $VM_A not found"
fi

# Delete VM-B
gcloud config set project "$PROJECT_B" >/dev/null
if gcloud compute instances describe "$VM_B" --zone="$ZONE" >/dev/null 2>&1; then
  gcloud compute instances delete "$VM_B" --zone="$ZONE" -q
  echo "Deleted: $VM_B"
else
  echo "Skip: $VM_B not found"
fi

# Delete peerings
gcloud config set project "$PROJECT_A" >/dev/null
if gcloud compute networks peerings describe "$PEER_A_TO_B" --network="$VPC_A" >/dev/null 2>&1; then
  gcloud compute networks peerings delete "$PEER_A_TO_B" --network="$VPC_A" -q
  echo "Deleted peering: $PEER_A_TO_B"
else
  echo "Skip: peering $PEER_A_TO_B not found"
fi

gcloud config set project "$PROJECT_B" >/dev/null
if gcloud compute networks peerings describe "$PEER_B_TO_A" --network="$VPC_B" >/dev/null 2>&1; then
  gcloud compute networks peerings delete "$PEER_B_TO_A" --network="$VPC_B" -q
  echo "Deleted peering: $PEER_B_TO_A"
else
  echo "Skip: peering $PEER_B_TO_A not found"
fi

# Delete firewall rules
gcloud config set project "$PROJECT_A" >/dev/null
for RULE in allow-icmp-from-b allow-iap-ssh-a; do
  if gcloud compute firewall-rules describe "$RULE" >/dev/null 2>&1; then
    gcloud compute firewall-rules delete "$RULE" -q
    echo "Deleted firewall: $RULE"
  else
    echo "Skip firewall: $RULE not found"
  fi
done

gcloud config set project "$PROJECT_B" >/dev/null
for RULE in allow-icmp-from-a allow-iap-ssh-b; do
  if gcloud compute firewall-rules describe "$RULE" >/dev/null 2>&1; then
    gcloud compute firewall-rules delete "$RULE" -q
    echo "Deleted firewall: $RULE"
  else
    echo "Skip firewall: $RULE not found"
  fi
done

# Delete subnet + VPC_B
gcloud config set project "$PROJECT_B" >/dev/null
if gcloud compute networks subnets describe "$SUBNET_B" --region="$REGION" >/dev/null 2>&1; then
  gcloud compute networks subnets delete "$SUBNET_B" --region="$REGION" -q
  echo "Deleted subnet: $SUBNET_B"
else
  echo "Skip: subnet $SUBNET_B not found"
fi

if gcloud compute networks describe "$VPC_B" >/dev/null 2>&1; then
  gcloud compute networks delete "$VPC_B" -q
  echo "Deleted VPC: $VPC_B"
else
  echo "Skip: VPC $VPC_B not found"
fi

echo "==> Cleanup complete."

