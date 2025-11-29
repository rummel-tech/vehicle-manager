# Vehicle Manager - URL Context Deployment Guide

This guide explains how to deploy the Vehicle Manager application with custom URL contexts (base paths) so it can run alongside other applications on the same server.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Deployment Scenarios](#deployment-scenarios)
- [Frontend Configuration](#frontend-configuration)
- [Backend Configuration](#backend-configuration)
- [Nginx Configuration](#nginx-configuration)
- [Testing](#testing)

## Overview

The Vehicle Manager application supports deployment under custom URL paths:

- **Root Deployment**: `https://yourdomain.com/`
- **Context Deployment**: `https://yourdomain.com/vehicle-manager/`

This allows multiple applications to coexist on the same domain:
- `https://yourdomain.com/` - Main site
- `https://yourdomain.com/vehicle-manager/` - Vehicle Manager
- `https://yourdomain.com/meal-planner/` - Other app
- `https://yourdomain.com/workout-planner/` - Other app

## Architecture

### Frontend (Flutter Web)
- **Base Href**: Set via `--base-href` flag during build
- **Config.js**: Dynamically determines API endpoint
- **AppConfig**: Dart class that reads runtime configuration

### Backend (FastAPI)
- **ROOT_PATH**: Environment variable for path prefix
- **CORS**: Configured to allow cross-origin requests
- **Docs**: Automatically adjusted to match root path

## Deployment Scenarios

### Scenario 1: Root Deployment (Default)

Application runs at domain root:
- Frontend: `https://yourdomain.com/`
- API: `https://yourdomain.com/api/`

```bash
# Frontend build
cd frontend/app/vehicle_app
flutter build web --release

# Backend run
cd backend
uvicorn main:app --host 0.0.0.0 --port 8030
```

### Scenario 2: Context Path Deployment

Application runs under `/vehicle-manager`:
- Frontend: `https://yourdomain.com/vehicle-manager/`
- API: `https://yourdomain.com/vehicle-manager/api/`

```bash
# Frontend build with base href
cd frontend/app/vehicle_app
flutter build web --release --base-href /vehicle-manager/

# Backend run with ROOT_PATH
cd backend
ROOT_PATH=/vehicle-manager/api uvicorn main:app --host 0.0.0.0 --port 8030
```

### Scenario 3: Subdomain Deployment

Application runs on subdomain:
- Frontend: `https://vehicles.yourdomain.com/`
- API: `https://vehicles.yourdomain.com/api/`

```bash
# Frontend build (root of subdomain)
cd frontend/app/vehicle_app
flutter build web --release

# Backend run
cd backend
uvicorn main:app --host 0.0.0.0 --port 8030
```

## Frontend Configuration

### Build Commands

#### Development (Local)
```bash
cd frontend/app/vehicle_app
flutter run -d chrome --web-port=8080
```

#### Production - Root Path
```bash
flutter build web --release
# Output: build/web/
```

#### Production - Custom Context
```bash
flutter build web --release --base-href /vehicle-manager/
# Output: build/web/
```

#### Production - Subdomain
```bash
flutter build web --release --base-href /
# Output: build/web/
```

### Configuration File (config.js)

The `web/config.js` file automatically detects the environment:

```javascript
window.appConfig = {
  // Auto-detects localhost vs production
  apiBaseUrl: window.location.hostname === 'localhost'
    ? 'http://localhost:8030'
    : '/api',

  // Reads from base href
  basePath: document.querySelector('base')?.getAttribute('href') || '/',

  // Debug mode for localhost
  debug: window.location.hostname === 'localhost'
};
```

You can override the API URL in production by setting `window.API_BASE_URL` before loading the app.

### Custom API URL Override

Edit `web/config.js` or set it via JavaScript:

```html
<script>
  // Set before loading Flutter app
  window.API_BASE_URL = 'https://api.example.com/vehicle-manager';
</script>
<script src="config.js"></script>
```

## Backend Configuration

### Environment Variables

```bash
# ROOT_PATH: URL prefix for all endpoints (optional)
ROOT_PATH=/vehicle-manager/api

# PORT: Port to run the server (default: 8000)
PORT=8030

# HOST: Host to bind to (default: 127.0.0.1)
HOST=0.0.0.0
```

### Running Backend

#### Development
```bash
cd backend
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8030
```

#### Production - Root Path
```bash
cd backend
source .venv/bin/activate
uvicorn main:app --host 0.0.0.0 --port 8030 --workers 4
```

#### Production - Context Path
```bash
cd backend
source .venv/bin/activate
ROOT_PATH=/vehicle-manager/api uvicorn main:app --host 0.0.0.0 --port 8030 --workers 4
```

### API Documentation

The API docs automatically adjust to the ROOT_PATH:

- Root deployment: `http://yourdomain.com/docs`
- Context deployment: `http://yourdomain.com/vehicle-manager/api/docs`

## Nginx Configuration

### Example 1: Root Deployment

```nginx
server {
    listen 80;
    server_name yourdomain.com;

    # Frontend (Flutter web)
    location / {
        root /var/www/vehicle-manager/frontend;
        try_files $uri $uri/ /index.html;
    }

    # Backend API
    location /api/ {
        proxy_pass http://127.0.0.1:8030/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Example 2: Context Path Deployment

```nginx
server {
    listen 80;
    server_name yourdomain.com;

    # Main site at root
    location / {
        root /var/www/main-site;
        try_files $uri $uri/ /index.html;
    }

    # Vehicle Manager Frontend
    location /vehicle-manager/ {
        alias /var/www/vehicle-manager/frontend/;
        try_files $uri $uri/ /vehicle-manager/index.html;
    }

    # Vehicle Manager API
    location /vehicle-manager/api/ {
        proxy_pass http://127.0.0.1:8030/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Example 3: Multiple Apps with Context Paths

```nginx
server {
    listen 80;
    server_name yourdomain.com;

    # Main site
    location / {
        root /var/www/main-site;
        try_files $uri $uri/ /index.html;
    }

    # Vehicle Manager
    location /vehicle-manager/ {
        alias /var/www/vehicle-manager/frontend/;
        try_files $uri $uri/ /vehicle-manager/index.html;
    }
    location /vehicle-manager/api/ {
        proxy_pass http://127.0.0.1:8030/;
        proxy_set_header Host $host;
    }

    # Meal Planner
    location /meal-planner/ {
        alias /var/www/meal-planner/frontend/;
        try_files $uri $uri/ /meal-planner/index.html;
    }
    location /meal-planner/api/ {
        proxy_pass http://127.0.0.1:8031/;
        proxy_set_header Host $host;
    }

    # Workout Planner
    location /workout-planner/ {
        alias /var/www/workout-planner/frontend/;
        try_files $uri $uri/ /workout-planner/index.html;
    }
    location /workout-planner/api/ {
        proxy_pass http://127.0.0.1:8032/;
        proxy_set_header Host $host;
    }
}
```

## Docker Deployment

### Dockerfile for Backend

```dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .

# Set ROOT_PATH via environment variable
ENV ROOT_PATH=""

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Docker Compose

```yaml
version: '3.8'

services:
  vehicle-manager-api:
    build: ./backend
    ports:
      - "8030:8000"
    environment:
      - ROOT_PATH=/vehicle-manager/api
    restart: unless-stopped

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
      - ./frontend/app/vehicle_app/build/web:/var/www/vehicle-manager/frontend
    depends_on:
      - vehicle-manager-api
    restart: unless-stopped
```

## Testing

### Test Local Development

```bash
# Terminal 1: Start backend
cd backend
source .venv/bin/activate
uvicorn main:app --reload --port 8030

# Terminal 2: Start frontend
cd frontend/app/vehicle_app
flutter run -d chrome --web-port=8080

# Open: http://localhost:8080
```

### Test Context Path Build

```bash
# Build with context path
cd frontend/app/vehicle_app
flutter build web --release --base-href /vehicle-manager/

# Serve with Python
cd build/web
python3 -m http.server 8081

# Manually test by navigating to:
# http://localhost:8081/vehicle-manager/
```

### Test API with Context Path

```bash
# Start backend with ROOT_PATH
cd backend
ROOT_PATH=/vehicle-manager/api uvicorn main:app --port 8030

# Test endpoints
curl http://localhost:8030/vehicle-manager/api/health
curl http://localhost:8030/vehicle-manager/api/docs

# Should return {"status": "ok"}
```

## Environment Variables Summary

### Frontend
- Configured via `web/config.js`
- Reads `window.API_BASE_URL` if set
- Auto-detects localhost vs production

### Backend
- `ROOT_PATH`: URL prefix (e.g., `/vehicle-manager/api`)
- `PORT`: Server port (default: 8000)
- `HOST`: Bind address (default: 127.0.0.1)

## Build Scripts

Create helper scripts for common deployments:

### `scripts/build-root.sh`
```bash
#!/bin/bash
cd frontend/app/vehicle_app
flutter build web --release
echo "Frontend built for root deployment: build/web/"
```

### `scripts/build-context.sh`
```bash
#!/bin/bash
CONTEXT_PATH=${1:-/vehicle-manager/}
cd frontend/app/vehicle_app
flutter build web --release --base-href "$CONTEXT_PATH"
echo "Frontend built for context path $CONTEXT_PATH: build/web/"
```

### `scripts/run-backend-context.sh`
```bash
#!/bin/bash
CONTEXT_PATH=${1:-/vehicle-manager/api}
cd backend
source .venv/bin/activate
ROOT_PATH="$CONTEXT_PATH" uvicorn main:app --host 0.0.0.0 --port 8030
```

## Troubleshooting

### Issue: 404 errors for static assets
**Solution**: Ensure base href ends with `/` (e.g., `/vehicle-manager/`)

### Issue: API calls fail with CORS errors
**Solution**: Check CORS configuration in backend `main.py`

### Issue: Flutter routing breaks on refresh
**Solution**: Configure nginx to use `try_files $uri $uri/ /index.html`

### Issue: API docs not accessible
**Solution**: Verify ROOT_PATH is set correctly and matches nginx proxy_pass

## Quick Reference

| Deployment | Frontend Build | Backend ENV | Nginx Location |
|------------|---------------|-------------|----------------|
| Root | `flutter build web` | `ROOT_PATH=""` | `/` and `/api/` |
| Context | `flutter build web --base-href /vehicle-manager/` | `ROOT_PATH=/vehicle-manager/api` | `/vehicle-manager/` and `/vehicle-manager/api/` |
| Subdomain | `flutter build web` | `ROOT_PATH=""` | `/` and `/api/` |

---

**Last Updated**: 2025-11-21
**Version**: 1.0.0
