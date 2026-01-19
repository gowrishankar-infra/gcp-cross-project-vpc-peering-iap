# Runbook: Lab 1 — Cross-Project VPC Peering + IAP SSH

## Golden rules (from failure modes)
- Run admin `gcloud` only from **Cloud Shell**, not inside VMs (prevents scope/service-account issues).
- Prefer **IAP SSH** over public SSH to avoid Cloud Shell IP drift.
- Avoid placeholders like `SUBNET_NAME_HERE`; always query the subnet name.

## Step map (gcloud + GUI)
### 1) Project selection
- GUI: Console top bar → switch project.
- gcloud: `gcloud config set project <PROJECT_ID>`

### 2) VPCs and subnets
- GUI: VPC network → VPC networks → Create VPC
- gcloud: `scripts/01_create_networks.sh`

### 3) Firewall rules (ICMP + IAP SSH)
- GUI: VPC network → Firewall → Create rule
- gcloud: `scripts/02_create_firewalls.sh` and `scripts/04_enable_iap_and_rules.sh`

### 4) VM creation
- GUI: Compute Engine → VM instances → Create
- gcloud: `scripts/03_create_vms.sh`

### 5) VPC peering
- GUI: VPC network → VPC network peering
- gcloud: `scripts/05_create_peering.sh`

### 6) Verify routes
- GUI: VPC network → Routes
- gcloud: `scripts/06_verify_routes.sh`

### 7) Connectivity test
- GUI: SSH → using IAP (or browser SSH)
- gcloud: `scripts/07_connectivity_test.sh`

