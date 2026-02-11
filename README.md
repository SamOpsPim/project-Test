# Cloud Cost Lab (FastAPI)

Small FastAPI lab application to simulate cloud usage and cost anomalies.

This repository is meant for academic/lab testing of cloud monitoring and FinOps workflows.

## Warning

This project is intentionally not production-ready:
- no authentication
- no database
- no Kubernetes
- intentionally inefficient endpoints

Use only in isolated test environments.

## Project Structure

```text
python-projects-anomalies/
├── app.py
├── requirements.txt
├── Dockerfile
├── .env.example
├── .gitignore
├── README.md
├── Cloud-Anomaly-Lab.postman_collection.json
└── deploy/
    ├── aws.md
    ├── azure.md
    └── gcp.md
```

## Local Setup

```bash
cd /Users/mac/Documents/GitHub/pim/python-projects-anomalies
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
export $(grep -v '^#' .env | xargs)
python app.py
```

Application default URL: `http://localhost:8000`

## VM Deployment (AWS EC2 / Azure VM / GCP Compute Engine)

Baseline flow for all providers:
1. Create a small Linux VM.
2. Open inbound port `8000`.
3. SSH into the VM.
4. Install Python + pip.
5. Clone/copy this repo.
6. Install dependencies and run `python app.py`.

Provider-specific instructions:
- [`deploy/aws.md`](deploy/aws.md)
- [`deploy/azure.md`](deploy/azure.md)
- [`deploy/gcp.md`](deploy/gcp.md)

## Optional Docker Deployment

```bash
docker build -t cloud-cost-lab .
docker run --rm -p 8000:8000 --name cloud-cost-lab cloud-cost-lab
```

## Endpoints and Their Roles

### Normal Endpoints

- `GET /`
  - Basic app response.
- `GET /health`
  - Health check endpoint.
- `GET /anomaly/status`
  - Returns anomaly flags and memory state.

### Anomaly Endpoints (Intentional Inefficiencies)

- `GET /anomaly/cpu?iterations=2000000`
  - Triggers heavy CPU work.
- `GET /anomaly/memory?size_kb=1024`
  - Appends memory chunks to a global list (soft memory leak).
- `GET /anomaly/memory/clear`
  - Clears accumulated memory chunks.
- `GET /anomaly/network?count=5&url=https://httpbin.org/get`
  - Generates outbound HTTP traffic (network egress).
- `GET /anomaly/logging?size_kb=20`
  - Writes large log messages (disk growth).

### Background Job

- A background task runs every 60 seconds (configurable) and performs useless CPU work.

## Environment Variables

### Required Core Variables

- `ENABLE_CPU=true`
- `ENABLE_MEMORY=true`
- `ENABLE_NETWORK=true`
- `ENABLE_LOGGING=true`
- `ENABLE_BACKGROUND_JOB=true`
- `PORT=8000`

### Optional Tuning Variables

- `CPU_ITERATIONS_DEFAULT=2000000`
- `MEMORY_CHUNK_KB=1024`
- `NETWORK_DEFAULT_COUNT=5`
- `NETWORK_TARGET_URL=https://httpbin.org/get`
- `LOG_ANOMALY_SIZE_KB=20`
- `LOG_FILE_PATH=app.log`
- `BACKGROUND_INTERVAL_SECONDS=60`
- `BACKGROUND_CPU_ITERATIONS=350000`

## Curl Test Examples

```bash
curl http://localhost:8000/health
curl http://localhost:8000/anomaly/status
curl "http://localhost:8000/anomaly/cpu?iterations=5000000"
curl "http://localhost:8000/anomaly/memory?size_kb=2048"
curl "http://localhost:8000/anomaly/network?count=10&url=https://httpbin.org/get"
curl "http://localhost:8000/anomaly/logging?size_kb=100"
curl http://localhost:8000/anomaly/memory/clear
```

## Notes

- Keep values low on micro VMs, then increase gradually.
- For long-running VM sessions, use `nohup` (see provider docs in `deploy/`).
