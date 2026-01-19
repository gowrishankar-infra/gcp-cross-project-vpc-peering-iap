#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# Lab 1: Cross-project VPC peering + IAP SSH
# Context script (constants)
# -----------------------------

echo "==> Setting variables (edit if needed)"

# Projects
export PROJECT_A="gs-net-host"
export PROJECT_B="gs-app-svc"

# Networks
export VPC_A="vpc-auto-a"
export VPC_B="vpc-custom-b"
export SUBNET_B="subnet-b"

# Region/Zone
export REGION="asia-south1"
export ZONE="asia-south1-a"

# CIDRs (as you used)
export CIDR_A="10.160.0.0/20"
export CIDR_B="10.20.0.0/16"

# VMs
export VM_A="vm-a"
export VM_B="vm-b"

# Peering names
export PEER_A_TO_B="peer-a-to-b"
export PEER_B_TO_A="peer-b-to-a"

# IAP TCP forwarding IP range (Google-managed)
export IAP_RANGE="35.235.240.0/20"

mkdir -p outputs

echo "==> Done. Current config:"
echo "PROJECT_A=$PROJECT_A"
echo "PROJECT_B=$PROJECT_B"
echo "VPC_A=$VPC_A"
echo "VPC_B=$VPC_B"
echo "REGION=$REGION"
echo "ZONE=$ZONE"
echo "CIDR_A=$CIDR_A"
echo "CIDR_B=$CIDR_B"
echo "VM_A=$VM_A"
echo "VM_B=$VM_B"
echo "PEER_A_TO_B=$PEER_A_TO_B"
echo "PEER_B_TO_A=$PEER_B_TO_A"
echo "IAP_RANGE=$IAP_RANGE"

echo
echo "NOTE:"
echo "- Run all scripts from Cloud Shell (not inside VMs)."
echo "- If a script says a resource already exists, that's fine."

