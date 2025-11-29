#!/bin/bash
# Build frontend for context path deployment
CONTEXT_PATH=${1:-/vehicle-manager/}
echo "Building Vehicle Manager for CONTEXT PATH: $CONTEXT_PATH"
cd "$(dirname "$0")/../frontend/app/vehicle_app"
flutter build web --release --base-href "$CONTEXT_PATH"
echo "✅ Frontend built for context path: $CONTEXT_PATH"
echo "📁 Output: build/web/"
echo "🚀 Deploy to: $CONTEXT_PATH"
