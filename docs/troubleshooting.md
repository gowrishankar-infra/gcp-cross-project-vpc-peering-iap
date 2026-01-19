# Troubleshooting Notes (Real failures encountered)

## 1) SSH timeout to VM external IP
**Symptom**
- `ssh: connect to host <ip> port 22: Connection timed out`

**Cause**
- Cloud Shell egress IP changed, but firewall allowed only previous `/32`.

**Fix**
- Standardize on IAP SSH:
  - Enable API: `gcloud services enable iap.googleapis.com`
  - Allow IAP range: `35.235.240.0/20` on tcp:22
  - Connect: `gcloud compute ssh <vm> --tunnel-through-iap`

**Prevention**
- Remove public SSH rules (`allow-ssh-*`) and keep only `allow-iap-ssh-*`.

---

## 2) Subnet not found
**Symptom**
- `...subnetworks/SUBNET_NAME_HERE... cannot be found`

**Cause**
- Placeholder used instead of actual subnet name.

**Fix**
- Query subnet name automatically:
  - `gcloud compute networks subnets list --filter="network:<vpc> AND region:<region>" --format="value(name)"`

---

## 3) Insufficient authentication scopes / wrong identity
**Symptom**
- `ACCESS_TOKEN_SCOPE_INSUFFICIENT` or gcloud acting as a compute service account

**Cause**
- Running admin `gcloud` commands from inside VM (uses VM service account scopes).

**Fix**
- Run project/VPC/firewall/peering commands from Cloud Shell under your user identity.

