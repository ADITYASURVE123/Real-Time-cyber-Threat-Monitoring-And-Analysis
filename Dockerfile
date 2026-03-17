# This multi-purpose Dockerfile is now unused in favor of Dockerfile.backend for the API.
# Keeping for reference; prefer building with Dockerfile.backend via docker-compose.
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt
COPY . /app
EXPOSE 5000
ENV PYTHONUNBUFFERED=1
CMD ["python", "-m", "backend.app"]
