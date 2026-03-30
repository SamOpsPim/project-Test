FROM python:3.11-slim

WORKDIR /app

RUN groupadd --gid 1000 appuser && \
    useradd --uid 1000 --gid appuser --create-home appuser

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

USER appuser

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

CMD ["python", "app.py"]
