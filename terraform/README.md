# Terraform — major cloud providers

Minimal VM stacks for the Cloud Anomaly Lab app (FastAPI on port **8000**, SSH on **22**). Each folder is a standalone root module: `cd` into it, copy `terraform.tfvars.example` to `terraform.tfvars`, adjust values, then `terraform init` and `terraform apply`.

| Directory | Provider | Notes |
|-----------|----------|--------|
| `aws/` | Amazon Web Services | EC2 `t3.micro`, Ubuntu 22.04, default VPC |
| `gcp/` | Google Cloud | `e2-micro`, Ubuntu 22.04, firewall for tagged instances |
| `azure/` | Microsoft Azure | `B1s`, Ubuntu 22.04, NSG allows 22 and 8000 |

After apply, SSH to the instance and run the app (see `../project-Test/deploy/*.md` or your image with Docker).

**Secrets:** Do not commit `terraform.tfvars` or private keys. Use remote state (S3, GCS, Azure Storage) for teams.
