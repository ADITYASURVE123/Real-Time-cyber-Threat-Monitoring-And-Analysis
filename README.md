# Cyber Incident Monitoring System

## Project Overview

The **Cyber Incident Monitoring System** is a comprehensive tool designed to provide real-time feeds of cyber incidents occurring in the cyber space within the Indian region. This tool aggregates data from various sources, including social media (e.g., Twitter), news websites, and other relevant feeds. It leverages machine learning to classify incidents and generates reports to help stakeholders understand the nature and frequency of cyber incidents in real-time. 

This project consists of a full-stack application with a backend that handles data collection, processing, and storage, as well as a frontend that presents data in an interactive and user-friendly interface.

---

## Features

- **Real-time Incident Collection**: Scrapes data from sources such as Twitter and news websites.
- **Incident Classification**: Uses a machine learning model to classify cyber incidents.
- **Visualization Dashboard**: Provides a frontend dashboard for visualizing and interacting with the data.
- **API Access**: Offers a REST API for accessing incident data and reports.
- **Configurable and Scalable**: Supports configurations for deployment in different environments.



---

## Technologies Used

### Frontend
- **Vanilla HTML/CSS/JavaScript**: Static files served by Flask; uses Chart.js, Leaflet, and simple DOM scripting.

### Backend
- **Flask 3.x**: API server handling incident ingest, queries, and reporting.
- **Flask-SQLAlchemy**: ORM for SQLite or PostgreSQL.
- **BeautifulSoup, requests, watchdog**: For scraping and file monitoring.

### Machine Learning
- **scikit-learn**: Lightweight model predicting incident severity.
- **pandas & numpy**: Data processing utilities.

### Deployment
- **Docker**: Containers for the backend and database.
- **Docker Compose**: Local development orchestration (see `docker-compose.yml`).
- **Kubernetes**: Example manifests provided under `deployment/k8s/` for production-style deployment.


---

## System Architecture

The project follows a microservices-based architecture, with each major component isolated for better scalability and maintainability. Here’s a quick overview:

1. **Frontend**: A React-based web application that connects to the backend API to display incidents data in real-time.
2. **Backend**: A Flask server that provides API endpoints for data ingestion, processing, and retrieval.
3. **Data Pipeline**: A data pipeline that collects data from sources such as Twitter and news websites, processes it, and stores it in the database.
4. **Machine Learning**: A trained model to classify incident types and severity based on historical data.
5. **Database**: A MongoDB/PostgreSQL database that stores raw and processed incident data.

---

## Setup Instructions

### Prerequisites

- [Node.js](https://nodejs.org/) and [npm](https://www.npmjs.com/) (for frontend)
- [Python 3.7+](https://www.python.org/)
- [Docker](https://www.docker.com/) (for containerization)
- Cloud provider account (optional, for deployment)

### Steps

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/your-username/cyber_incident_monitoring.git
   cd cyber_incident_monitoring
   ```

2. **Prepare Python Environment** (Windows example shown below):
   ```powershell
   python -m venv venv
   .\venv\Scripts\activate
   pip install -r requirements.txt
   ```

3. **Configure Database** (optional – defaults to `sqlite:///cyber_incidents.db`):
   ```powershell
   $env:DATABASE_URL = "postgresql://postgres:postgres@localhost:5432/cyber_incidents"
   ```

4. **Run the Backend Locally**:
   ```bash
   python -m backend.app
   ```

5. **Access the Web UI**:
   Open <http://127.0.0.1:5000/> in your browser.


## Testing

Unit tests are written with `pytest` and cover API endpoints and ML prediction.

```bash
# run from repository root with virtualenv active
pytest tests/
```


## Deployment

### Docker Compose (local development)

A `docker-compose.yml` at the project root builds the backend and a PostgreSQL database together:

```bash
# build & start services
docker-compose up --build

# once finished, access http://localhost:5000/
```

An alternative compose file with a frontend service exists under `deployment/docker-compose.yml`.

### Kubernetes

Example resources are provided in `deployment/k8s/`.  They include a `Deployment` and `Service` for the backend as well as a basic PostgreSQL deployment.

```yaml
# combined file for kubectl apply -f
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: your-backend-image:latest
        env:
          - name: DATABASE_URL
            value: postgresql://postgres:postgres@postgres:5432/cyber_incidents
        ports:
        - containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  selector:
    app: backend
  ports:
    - protocol: TCP
      port: 5000
      targetPort: 5000

---
# simple postgres deployment for demonstration
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:15-alpine
        env:
          - name: POSTGRES_DB
            value: cyber_incidents
          - name: POSTGRES_USER
            value: cyber_admin
          - name: POSTGRES_PASSWORD
            value: "postgres"
        ports:
        - containerPort: 5432
---
apiVersion: v1
kind: Service
metadata:
  name: postgres
spec:
  selector:
    app: postgres
  ports:
    - protocol: TCP
      port: 5432
      targetPort: 5432
```

Apply with:

```bash
kubectl apply -f deployment/k8s/backend-deployment.yaml
kubectl apply -f deployment/k8s/backend-service.yaml
# ...or apply the combined manifest above
```

You can push the backend image to a registry and update `image:` fields accordingly.


---

## Quick Start (Windows PowerShell)

This repository includes a ready-to-use Python virtual environment under `backend/venv` and a static frontend served by Flask.

1) Optional: configure database (defaults to local SQLite file `cyber_incidents.db`)

```powershell
$env:DATABASE_URL = "postgresql://cyber_admin:123456789@localhost:5432/cyber_incidents"
```

2) Install Python dependencies into the existing venv

```powershell
& "backend\venv\Scripts\python.exe" -m pip install -r requirements.txt
```

3) Run the backend (serves the dashboard from `frontend/`)

```powershell
& "backend\venv\Scripts\python.exe" -m backend.app
```

4) Verify locally

```powershell
# Dashboard
start http://127.0.0.1:5000/

# Sample alerts JSON
powershell -Command "(Invoke-WebRequest -UseBasicParsing http://127.0.0.1:5000/api/alerts).Content"

# ML prediction example
curl -X POST http://127.0.0.1:5000/api/predict-log -H "Content-Type: application/json" -d '{"src_port":443,"dst_port":52345,"packet_size":900,"protocol":6,"src_ip":"10.0.0.5"}'
```

Notes:
- Set `DATABASE_URL` only if using Postgres. Without it, the app uses SQLite automatically.
- The frontend is static and is already served by Flask; Node build is not required for demo.

---

## Usage

### Access the Web Application

Once the frontend and backend servers are running, open [http://localhost:3000](http://localhost:3000) in your browser to access the web application.

### Running the Data Pipeline

To collect and process real-time data:

```bash
python data_pipeline/jobs/ingest_data.py
```

### Access API Endpoints

The backend provides several API endpoints:

- **`GET /api/incidents`**: Retrieve a list of cyber incidents.
- **`POST /api/incidents`**: Add a new cyber incident (for testing).
- **`GET /api/incidents/<id>`**: Retrieve details of a specific incident.

---

## API Endpoints

Here are some core API endpoints for interacting with the backend.

1. **Get All Incidents**:
   ```http
   GET /api/incidents
   ```

2. **Get Incident by ID**:
   ```http
   GET /api/incidents/<id>
   ```

3. **Add Incident** (for testing purposes):
   ```http
   POST /api/incidents
   ```

---

## Deployment

### Docker Compose (Local)

You can deploy the whole stack using Docker Compose for local testing:

```bash
docker compose up --build
```

### Cloud Deployment (AWS/GCP)

1. **Build Docker Image**:
   ```bash
   docker build -t your-image-name .
   ```

2. **Push to Container Registry**:
   ```bash
   docker push your-image-name
   ```

3. **Deploy to Kubernetes**:
   - Use the Kubernetes manifests in the `deployment/k8s/` folder to deploy on a Kubernetes cluster.

---

## License

Content protected. Unauthorized use prohibited without explicit permission. Reach out for permissions before sharing or adapting this work . rajeevsharmamachphy@gmail.com 

---
