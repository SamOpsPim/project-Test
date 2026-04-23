# Terraform — lab infrastructure

Minimal VM stack for the Cloud Anomaly Lab app (FastAPI on port **8000**, SSH on **22**).

## Active module

| Directory | Provider | Notes |
|-----------|----------|--------|
| `aws/` | Amazon Web Services | EC2 (default `t3.nano`), Ubuntu 22.04, default VPC. **You must set `ssh_cidr_blocks`** in `terraform.tfvars` to your IP or VPN (open `0.0.0.0/0` is rejected). Optional EventBridge Scheduler stop/start for intermittent labs. |

## Archived (optional clouds)

Azure and GCP Terraform roots live under [`archive/`](./archive/README.md). Use them only when you deploy those providers and connect cost data; otherwise they stay out of the default FinOps scope.

**Secrets:** Do not commit `terraform.tfvars` or private keys. Use remote state (S3, GCS, Azure Storage) for teams.

After apply, SSH to the instance and run the app (see `../deploy/*.md` or your image with Docker).
