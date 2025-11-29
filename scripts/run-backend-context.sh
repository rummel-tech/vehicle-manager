#!/bin/bash
# Run backend with context path
CONTEXT_PATH=${1:-/vehicle-manager/api}
echo "Starting Vehicle Manager API with ROOT_PATH: $CONTEXT_PATH"
cd "$(dirname "$0")/../backend"
source .venv/bin/activate
ROOT_PATH="$CONTEXT_PATH" uvicorn main:app --host 0.0.0.0 --port 8030 --reload
