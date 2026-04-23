# Archived Terraform (Azure / GCP)

These root modules were moved here because FinOps ingestion showed **no Azure or GCP costs** for this repository while AWS did register spend. Keeping unused multi-cloud definitions in the active `terraform/` tree creates a false impression that all three clouds are deployed and complicates cost visibility.

**If you intend to deploy Azure or GCP:** copy the desired folder back to `terraform/azure` or `terraform/gcp`, wire up provider credentials and cost export for that cloud, then apply from that directory as a standalone root module (same workflow as `terraform/aws`).

**AWS** remains the canonical lab stack under `terraform/aws/`.
