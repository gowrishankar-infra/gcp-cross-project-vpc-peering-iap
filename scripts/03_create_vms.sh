#!/usr/bin/env bash
set -euo pipefail

source scripts/00_set_context.sh >/dev/null 2>&1 || true

echo "==> Create VM-A (Project A) and VM-B (Project B) in $ZONE"

# --- Project A: VM-A in auto subnet for REGION (auto-subnet name equals region in some setups; in your case it was vpc-auto-a)
gcloud config set project "$PROJECT_A" >/dev/null

SUBNET_A="$(gcloud compute networks subnets list \
  --filter="network:$VPC_A AND region:$REGION" \
  --format="value(name)" | head -n 1)"

if [[ -z "${SUBNET_A}" ]]; then
  echo "ERROR: Could not find subnet for $VPC_A in $REGION."
  echo "Fix: ensure $VPC_A has a subnet in $REGION."
  exit 1
fi

echo "Detected SUBNET_A=$SUBNET_A"

if gcloud compute instances describe "$VM_A" --zone="$ZONE" >/dev/null 2>&1; then
  echo "OK: $VM_A already exists"
else
  gcloud compute instances create "$VM_A" \
    --zone="$ZONE" \
    --subnet="$SUBNET_A" \
    --machine-type=e2-micro \
    --image-family=debian-12 \
    --image-project=debian-cloud
  echo "Created: $VM_A"
fi

# --- Project B: VM-B in subnet-b
gcloud config set project "$PROJECT_B" >/dev/null

if gcloud compute instances describe "$VM_B" --zone="$ZONE" >/dev/null 2>&1; then
  echo "OK: $VM_B already exists"
else
  gcloud compute instances create "$VM_B" \
    --zone="$ZONE" \
    --subnet="$SUBNET_B" \
    --machine-type=e2-micro \
    --image-family=debian-12 \
    --image-project=debian-cloud
  echo "Created: $VM_B"
fi

echo "==> Evidence: VM list + private IPs"
gcloud config set project "$PROJECT_A" >/dev/null
gcloud compute instances list \
  --filter="name=($VM_A)" \
  --format="table(name,zone,status,networkInterfaces[0].networkIP)" | tee "outputs/vm_project_a.txt"

gcloud config set project "$PROJECT_B" >/dev/null
gcloud compute instances list \
  --filter="name=($VM_B)" \
  --format="table(name,zone,status,networkInterfaces[0].networkIP)" | tee "outputs/vm_project_b.txt"

echo "==> Done."

