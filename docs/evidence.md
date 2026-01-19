# Evidence — What was verified

## Peering status
- `gcloud compute networks peerings list --network=vpc-auto-a` → ACTIVE
- `gcloud compute networks peerings list --network=vpc-custom-b` → ACTIVE

## Routes
- Project A route to 10.20.0.0/16 via peer-a-to-b
- Project B route to 10.160.0.0/20 via peer-b-to-a

## Firewall posture
- IAP SSH only:
  - allow-iap-ssh-a: tcp:22 from 35.235.240.0/20
  - allow-iap-ssh-b: tcp:22 from 35.235.240.0/20
- ICMP limited to peer CIDR ranges:
  - allow-icmp-from-b: icmp from 10.20.0.0/16
  - allow-icmp-from-a: icmp from 10.160.0.0/20

## Connectivity test (private IP ping)
- vm-a → vm-b (10.20.0.2) 0% loss
- vm-b → vm-a (10.160.0.2) 0% loss

## Outputs generated
See `outputs/` directory for proof logs captured during execution.

