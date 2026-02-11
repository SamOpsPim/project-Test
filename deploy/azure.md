# Azure VM Deployment (Lab)

## 1) Recommended VM Size

- VM size: `B1s` (or `B1ls`)
- OS: Ubuntu 22.04 LTS

## 2) Open Port 8000

In Azure NSG inbound rules, allow:
- Protocol: TCP
- Destination port: `8000`
- Source: your IP (recommended for lab) or Any

## 3) SSH to VM

```bash
ssh <azure_username>@<AZURE_VM_PUBLIC_IP>
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
curl http://<AZURE_VM_PUBLIC_IP>:8000/health
```
