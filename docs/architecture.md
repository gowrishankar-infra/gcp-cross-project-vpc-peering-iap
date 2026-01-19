
# Architecture — Cross-Project VPC Peering + IAP SSH

## Goal
Enable private connectivity between two isolated GCP projects using VPC Peering, and access VMs securely without exposing SSH publicly.

## Components
### Project A: gs-net-host
- Network: vpc-auto-a (AUTO mode)
- Region: asia-south1
- CIDR: 10.160.0.0/20
- VM: vm-a (10.160.0.2)

### Project B: gs-app-svc
- Network: vpc-custom-b (CUSTOM)
- Subnet: subnet-b (10.20.0.0/16)
- VM: vm-b (10.20.0.2)

## Connectivity
- VPC Peering:
  - peer-a-to-b (A → B)
  - peer-b-to-a (B → A)
- Route propagation:
  - A learns 10.20.0.0/16 via peer-a-to-b
  - B learns 10.160.0.0/20 via peer-b-to-a

## Security model
- Admin access via IAP SSH:
  - Firewall allows tcp:22 only from 35.235.240.0/20 (IAP range)
  - No public SSH rules required
- ICMP allowed only between CIDR ranges for connectivity proof

