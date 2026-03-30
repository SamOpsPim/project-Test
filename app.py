import asyncio
import gc
import hashlib
import logging
import os
from contextlib import asynccontextmanager
from typing import Any

import requests
import uvicorn
from fastapi import FastAPI, HTTPException, Query, Request


def env_bool(name: str, default: bool) -> bool:
    value = os.getenv(name, str(int(default))).strip().lower()
    return value in {"1", "true", "yes", "on"}


def env_int(name: str, default: int) -> int:
    raw = os.getenv(name)
    if raw is None:
        return default
    try:
        return int(raw)
    except ValueError:
        return default


# Primary flags requested by the lab spec, with backward-compatible fallbacks.
ENABLE_CPU = env_bool("ENABLE_CPU", env_bool("ENABLE_CPU_ANOMALY", True))
ENABLE_MEMORY = env_bool("ENABLE_MEMORY", env_bool("ENABLE_MEMORY_ANOMALY", True))
ENABLE_NETWORK = env_bool("ENABLE_NETWORK", env_bool("ENABLE_NETWORK_ANOMALY", True))
ENABLE_LOGGING = env_bool("ENABLE_LOGGING", env_bool("ENABLE_LOGGING_ANOMALY", True))
ENABLE_BACKGROUND_JOB = env_bool(
    "ENABLE_BACKGROUND_JOB", env_bool("ENABLE_BACKGROUND_ANOMALY", True)
)

DEFAULT_CPU_ITERATIONS = env_int("CPU_ITERATIONS_DEFAULT", 2_000_000)
MEMORY_CHUNK_KB = env_int("MEMORY_CHUNK_KB", 1024)
NETWORK_DEFAULT_COUNT = env_int("NETWORK_DEFAULT_COUNT", 5)
NETWORK_TARGET_URL = os.getenv("NETWORK_TARGET_URL", "https://httpbin.org/get")
LOG_ANOMALY_SIZE_KB = env_int("LOG_ANOMALY_SIZE_KB", 20)
BACKGROUND_INTERVAL_SECONDS = env_int("BACKGROUND_INTERVAL_SECONDS", 60)
BACKGROUND_CPU_ITERATIONS = env_int("BACKGROUND_CPU_ITERATIONS", 350_000)

LOG_FILE_PATH = os.getenv("LOG_FILE_PATH", "app.log")
HOST = os.getenv("HOST", "0.0.0.0")
PORT = int(os.getenv("PORT", 8000))

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s [%(name)s] %(message)s",
    handlers=[
        logging.FileHandler(LOG_FILE_PATH),
        logging.StreamHandler(),
    ],
)
logger = logging.getLogger("anomaly-app")


@asynccontextmanager
async def lifespan(application: FastAPI):
    task = asyncio.create_task(background_worker())
    application.state.background_task = task
    yield
    task.cancel()
    try:
        await task
    except asyncio.CancelledError:
        pass


app = FastAPI(title="Cloud Anomaly Lab App", lifespan=lifespan)

# ANOMALY: Memory growth. This list intentionally keeps growing.
memory_bucket: list[bytes] = []


def require_enabled(flag: bool, feature_name: str) -> None:
    if not flag:
        raise HTTPException(status_code=404, detail=f"{feature_name} anomaly is disabled.")


def run_cpu_burn(iterations: int) -> int:
    # ANOMALY: CPU usage. Intentionally performs unnecessary hashing.
    digest_total = 0
    for i in range(iterations):
        digest = hashlib.sha256(f"finops-lab-{i}".encode("utf-8")).hexdigest()
        digest_total += int(digest[:8], 16)
    return digest_total


@app.middleware("http")
async def verbose_logging_middleware(request: Request, call_next):
    response = await call_next(request)
    if ENABLE_LOGGING:
        # ANOMALY: Disk growth through excessive logging on every request.
        noisy_message = "L" * (LOG_ANOMALY_SIZE_KB * 1024)
        logger.info(
            "request=%s path=%s status=%s noisy_payload=%s",
            request.method,
            request.url.path,
            response.status_code,
            noisy_message,
        )
    return response


@app.get("/")
def root() -> dict[str, str]:
    return {"message": "Cloud anomaly lab app is running."}


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/anomaly/status")
def anomaly_status() -> dict[str, Any]:
    total_memory_bytes = sum(len(chunk) for chunk in memory_bucket)
    return {
        "cpu_enabled": ENABLE_CPU,
        "memory_enabled": ENABLE_MEMORY,
        "network_enabled": ENABLE_NETWORK,
        "logging_enabled": ENABLE_LOGGING,
        "background_enabled": ENABLE_BACKGROUND_JOB,
        "memory_chunks": len(memory_bucket),
        "memory_bytes": total_memory_bytes,
    }


@app.get("/anomaly/cpu")
def cpu_anomaly(iterations: int = Query(default=DEFAULT_CPU_ITERATIONS, ge=1, le=50_000_000)) -> dict[str, Any]:
    # ANOMALY: CPU usage.
    require_enabled(ENABLE_CPU, "CPU")
    result = run_cpu_burn(iterations)
    return {"iterations": iterations, "checksum": result}


@app.get("/anomaly/memory")
def memory_anomaly(size_kb: int = Query(default=MEMORY_CHUNK_KB, ge=1, le=10_240)) -> dict[str, Any]:
    # ANOMALY: Memory growth.
    require_enabled(ENABLE_MEMORY, "Memory")
    # ANOMALY: Memory growth. Appends chunk and never evicts by default.
    payload = b"M" * (size_kb * 1024)
    memory_bucket.append(payload)
    total_memory_bytes = sum(len(chunk) for chunk in memory_bucket)
    return {
        "added_kb": size_kb,
        "chunks": len(memory_bucket),
        "memory_bytes": total_memory_bytes,
    }


@app.get("/anomaly/memory/clear")
def clear_memory_anomaly() -> dict[str, Any]:
    require_enabled(ENABLE_MEMORY, "Memory")
    memory_bucket.clear()
    gc.collect()
    return {"cleared": True, "chunks": 0, "memory_bytes": 0}


@app.get("/anomaly/network")
def network_anomaly(
    count: int = Query(default=NETWORK_DEFAULT_COUNT, ge=1, le=100),
    url: str = Query(default=NETWORK_TARGET_URL),
) -> dict[str, Any]:
    # ANOMALY: Network egress via unnecessary outbound requests.
    require_enabled(ENABLE_NETWORK, "Network")
    statuses: list[int | None] = []
    bytes_received = 0
    for _ in range(count):
        try:
            resp = requests.get(url, timeout=5)
            statuses.append(resp.status_code)
            bytes_received += len(resp.content)
        except Exception:
            statuses.append(None)
    return {
        "request_count": count,
        "target_url": url,
        "statuses": statuses,
        "bytes_received": bytes_received,
    }


@app.get("/anomaly/logging")
def logging_anomaly(size_kb: int = Query(default=LOG_ANOMALY_SIZE_KB, ge=1, le=512)) -> dict[str, Any]:
    # ANOMALY: Disk growth through large useless log messages.
    require_enabled(ENABLE_LOGGING, "Logging")
    noisy_message = "X" * (size_kb * 1024)
    logger.info("manual_logging_anomaly payload=%s", noisy_message)
    return {"logged_kb": size_kb}


async def background_worker() -> None:
    while True:
        await asyncio.sleep(BACKGROUND_INTERVAL_SECONDS)
        if ENABLE_BACKGROUND_JOB:
            # ANOMALY: Background CPU usage every minute.
            checksum = run_cpu_burn(BACKGROUND_CPU_ITERATIONS)
            logger.info("background_task checksum=%s", checksum)


if __name__ == "__main__":
    uvicorn.run(app, host=HOST, port=PORT)
