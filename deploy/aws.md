# AWS EC2 Deployment (Lab)

## 1) Recommended VM Size

- Instance type: `t3.micro` (or `t2.micro`)
- OS: Ubuntu 22.04 LTS

## 2) Open Port 8000

In the EC2 Security Group, add inbound rule:
- Type: Custom TCP
- Port: `8000`
- Source: your public IP as a `/32` CIDR (required by the Terraform defaults; avoid open `0.0.0.0/0`)

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
