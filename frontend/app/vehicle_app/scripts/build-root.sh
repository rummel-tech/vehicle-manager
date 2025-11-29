#!/bin/bash
# Build frontend for root deployment
echo "Building Vehicle Manager for ROOT deployment..."
cd ../frontend/app/vehicle_app
flutter build web --release
echo "✅ Frontend built for root deployment"
echo "📁 Output: build/web/"
echo "🚀 Deploy to: /"
