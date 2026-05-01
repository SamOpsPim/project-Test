# Terraform — major cloud providers

Minimal VM stacks for the Cloud Anomaly Lab app (FastAPI on port **8000**, SSH on **22**). Each folder is a standalone root module: `cd` into it, copy `terraform.tfvars.example` to `terraform.tfvars`, adjust values, then `terraform init` and `terraform apply`.

**Inbound access:** Set trusted CIDRs in `terraform.tfvars` (for example your public IP as `/32`). Open internet (`0.0.0.0/0` / `::/0`) is rejected by variable validation so `apply` cannot widen SSH or port 8000 to the world by default.

**AWS VPC cost:** This stack uses the default VPC and an ephemeral public IP only (no `aws_eip` or NAT gateway in Terraform). If billing shows high “VPC” charges, use Cost Explorer to check for stray Elastic IPs, NAT gateways, or data transfer outside this module.

| Directory | Provider | Notes |
|-----------|----------|--------|
| `aws/` | Amazon Web Services | EC2 `t3.micro`, Ubuntu 22.04, default VPC |
| `gcp/` | Google Cloud | `e2-micro`, Ubuntu 22.04, firewall for tagged instances |
| `azure/` | Microsoft Azure | `B1s`, Ubuntu 22.04, NSG allows 22 and 8000 |

After apply, SSH to the instance and run the app (see `../project-Test/deploy/*.md` or your image with Docker).

**Secrets:** Do not commit `terraform.tfvars` or private keys. Use remote state (S3, GCS, Azure Storage) for teams.
