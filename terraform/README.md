# Terraform — AWS lab stack

Minimal VM stack for the Cloud Anomaly Lab app (FastAPI on port **8000**, SSH on **22**). This is a standalone root module: `cd terraform/aws`, copy `terraform.tfvars.example` to `terraform.tfvars`, set **trusted** `ssh_cidr_blocks` and `app_cidr_blocks` (never `0.0.0.0/0`), then `terraform init` and `terraform apply`.

| Directory | Provider | Notes |
|-----------|----------|--------|
| `aws/` | Amazon Web Services | Dedicated VPC + public subnet, `t3a.nano` default, NSG-style SG rules, cost allocation tags, CPU alarm for rightsizing hints |

Azure and GCP are documented for **manual** VM setup in [`../deploy/azure.md`](../deploy/azure.md) and [`../deploy/gcp.md`](../deploy/gcp.md); Terraform modules for those providers were removed to avoid IaC drift when those clouds are not in scope for cost ingestion.

**Secrets:** Do not commit `terraform.tfvars` or private keys. Use remote state (S3) for teams.
