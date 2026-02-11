# GCP Compute Engine Deployment (Lab)

## 1) Recommended VM Size

- Machine type: `e2-micro`
- OS: Ubuntu 22.04 LTS

## 2) Open Port 8000

Create a VPC firewall rule allowing inbound TCP `8000` to the VM.

Example with gcloud:

```bash
gcloud compute firewall-rules create allow-cloud-cost-lab-8000 \
  --allow=tcp:8000 \
  --target-tags=cloud-cost-lab
```

Apply tag `cloud-cost-lab` to your VM network tags.

## 3) SSH to VM

```bash
gcloud compute ssh <VM_NAME> --zone <ZONE>
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
curl http://<GCP_VM_EXTERNAL_IP>:8000/health
```
