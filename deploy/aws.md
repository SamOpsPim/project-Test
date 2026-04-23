# AWS EC2 Deployment (Lab)

## 1) Recommended VM Size

- Terraform default: `t3.nano` (lower cost than `t3.micro` for the same lab workload).
- OS: Ubuntu 22.04 LTS

## 2) Open Port 8000

In the EC2 Security Group, add inbound rule:
- Type: Custom TCP
- Port: `8000`
- Source: **your IP or VPN CIDR only** (do not use `0.0.0.0/0` on the public internet).

If you use the Terraform under `terraform/aws/`, set `ssh_cidr_blocks` in `terraform.tfvars` to that same trusted range; open-world CIDRs are blocked by validation. Optional: set `enable_instance_schedule = true` for automatic stop/start windows to reduce compute when the lab is idle.

## 3) SSH to VM

```bash
ssh -i /path/to/key.pem ubuntu@<EC2_PUBLIC_IP>
```

## 4) Install Python

```bash
sudo apt update
sudo apt install -y python3 python3-venv python3-pip git
```

## 5) Clone Repo

```bash
git clone <YOUR_REPO_URL>
cd python-projects-anomalies
```

## 6) Run App

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
python app.py
```

## 7) Keep App Running (nohup)

```bash
nohup .venv/bin/python app.py > output.log 2>&1 &
```

Check process:

```bash
ps aux | grep app.py
```

Test from local machine:

```bash
curl http://<EC2_PUBLIC_IP>:8000/health
```
