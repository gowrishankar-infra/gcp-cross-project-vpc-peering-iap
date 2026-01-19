# GCP Cross-Project VPC Peering + IAP SSH (SRE Lab)

## What this repo proves (Recruiter Summary)
This lab demonstrates production-style GCP networking across two projects:
- Cross-project private connectivity using **VPC Peering**
- Verified **ACTIVE** peering on both sides and confirmed **route propagation**
- Secured admin access using **IAP (Identity-Aware Proxy) SSH** (no public SSH dependency)
- End-to-end connectivity proof via private IP ping (`10.160.0.0/20 ↔ 10.20.0.0/16`)
- SRE-grade artifacts: **runbook, troubleshooting notes, evidence outputs**

## Architecture
- **Project A (Host-like)**: `gs-net-host`
  - Auto VPC: `vpc-auto-a`
  - Subnet CIDR: `10.160.0.0/20`
  - VM: `vm-a` (private IP `10.160.0.2`)
- **Project B (Service-like)**: `gs-app-svc`
  - Custom VPC: `vpc-custom-b`
  - Subnet: `subnet-b` (`10.20.0.0/16`)
  - VM: `vm-b` (private IP `10.20.0.2`)

Connectivity:
- VPC Peering: `peer-a-to-b` and `peer-b-to-a`
- IAP SSH enabled via firewall source range: `35.235.240.0/20`
- ICMP allowed between CIDRs (for ping proof)

See: `docs/architecture.md`

## Why I used IAP SSH (Real-world)
Cloud Shell public IP can change, breaking `/32` SSH rules.  
IAP SSH is enterprise-grade: no inbound public SSH dependency.

## How to run (Cloud Shell)
> IMPORTANT: Run all scripts from **Cloud Shell**, not inside VMs.

```bash
chmod +x scripts/*.sh

./scripts/01_create_networks.sh
./scripts/02_create_firewalls.sh
./scripts/03_create_vms.sh
./scripts/04_enable_iap_and_rules.sh
./scripts/05_create_peering.sh
./scripts/06_verify_routes.sh
./scripts/07_connectivity_test.sh

