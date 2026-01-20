# Vehicle Manager

Comprehensive vehicle tracking application for maintenance, fuel, mileage, and service records with FastAPI backend and Flutter web frontend.

## 🚗 Features

- **Multi-Vehicle Support**: Track multiple vehicles from one account
- **Maintenance Tracking**: Complete service history with costs and schedules
- **Fuel Tracking**: Log fill-ups, calculate MPG, track fuel costs
- **Mileage Monitoring**: Track current mileage across all vehicles
- **Service Schedules**: Automated maintenance reminders based on mileage
- **Cost Analytics**: Track total costs for fuel and maintenance
- **Statistics Dashboard**: View MPG averages, total costs, and service history
- **Responsive UI**: Beautiful Flutter web interface with Material Design 3

## 📁 Project Structure

```
vehicle-manager/
├── backend/                    # FastAPI backend
│   ├── main.py                # API endpoints
│   ├── requirements.txt       # Python dependencies
│   └── Dockerfile             # Container configuration
├── frontend/                   # Flutter frontend
│   ├── app/vehicle_app/       # Main Flutter application
│   └── packages/vehicle_ui/   # Reusable UI components
└── .github/workflows/         # CI/CD workflows
    ├── deploy-frontend.yml    # GitHub Pages deployment
    └── deploy-backend.yml     # AWS ECS deployment
```

## 🏃 Quick Start

### Backend Development

```bash
cd backend
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8030
```

Visit: http://localhost:8030/docs

### Frontend Development

```bash
cd frontend/app/vehicle_app
flutter pub get
flutter run -d chrome
```

### Docker

```bash
cd backend
docker build -t vehicle-manager:local .
docker run -p 8030:8000 vehicle-manager:local
```

## 📡 API Endpoints

### Vehicles
- `GET /vehicles/{user_id}` - Get all vehicles for user
- `GET /vehicles/{user_id}/{vehicle_id}` - Get specific vehicle details

### Maintenance
- `GET /maintenance/{vehicle_id}` - Get all maintenance records
- `GET /maintenance/{vehicle_id}/type/{service_type}` - Get records by type

### Fuel
- `GET /fuel/{vehicle_id}` - Get fuel records (optional limit param)

### Schedules & Stats
- `GET /schedule/{vehicle_id}` - Get maintenance schedule
- `GET /stats/{vehicle_id}` - Get vehicle statistics
- `GET /summary/{user_id}` - Get summary for all vehicles

### Health
- `GET /health` - Health check
- `GET /ready` - Readiness check

### Example Usage

```bash
# Get all vehicles
curl http://localhost:8030/vehicles/user-123

# Get vehicle details
curl http://localhost:8030/vehicles/user-123/v1

# Get maintenance records
curl http://localhost:8030/maintenance/v1

# Get fuel records (last 5)
curl http://localhost:8030/fuel/v1?limit=5

# Get maintenance schedule
curl http://localhost:8030/schedule/v1

# Get vehicle statistics
curl http://localhost:8030/stats/v1

# Get user summary
curl http://localhost:8030/summary/user-123
```

## 🚢 Deployment

### Prerequisites

**GitHub Secrets**:
- `AWS_ROLE_TO_ASSUME` - AWS IAM role ARN for OIDC authentication

**GitHub Pages**:
1. Go to Settings → Pages
2. Source: Deploy from a branch
3. Branch: `gh-pages` (created automatically)

### Automatic Deployment

Push to `main` branch triggers deployment:

```bash
git add .
git commit -m "Update vehicle manager"
git push origin main
```

### Access URLs

After deployment:
- **Frontend**: https://srummel.github.io/vehicle-manager/
- **Backend API**: http://<ECS_IP>:8000/docs

## 🔧 Configuration

### Update API URL

For production, update in `frontend/packages/vehicle_ui/lib/services/vehicle_api_service.dart`:

```dart
VehicleApiService({this.baseUrl = 'https://api.yourdomain.com'});
```

## 📊 Maintenance Types

- **oil_change** - Oil changes and filter replacements
- **tire_rotation** - Tire rotation and balancing
- **brake_service** - Brake pad/rotor replacement
- **inspection** - State/safety inspections
- **repair** - General repairs

## 🎨 UI Components

### Vehicle Card
- Display vehicle info (make, model, year)
- Current mileage
- License plate
- Color indicator

### Maintenance Card
- Service type with icon
- Date and mileage
- Cost
- Next due information
- Service description

### Fuel Card
- Fill-up date and location
- Gallons and cost
- Price per gallon
- Calculated MPG

## 📈 Statistics

### Vehicle Stats
- Average MPG
- Total fuel cost
- Total gallons purchased
- Total maintenance cost
- Number of services
- Last service date

### User Summary
- Total vehicles
- Combined fuel costs
- Combined maintenance costs
- Total cost across all vehicles

## 🧪 Testing

### Backend
```bash
cd backend
pytest
```

### Frontend
```bash
cd frontend/app/vehicle_app
flutter test
```

## 📝 Development Workflow

1. Create feature branch
2. Make changes and test locally
3. Commit and push
4. Create Pull Request
5. Merge to main (triggers deployment)

## 🎯 Roadmap

- [ ] User authentication
- [ ] Persistent database (PostgreSQL)
- [ ] Add/edit/delete records
- [ ] Photo uploads for receipts
- [ ] Recurring maintenance reminders
- [ ] Export records to PDF/CSV
- [ ] Insurance tracking
- [ ] Registration renewal reminders
- [ ] Tire pressure monitoring
- [ ] Mobile app (iOS/Android)

## 🔗 Related Projects

- **Workout Planner**: https://github.com/srummel/workout-planner
- **Meal Planner**: https://github.com/srummel/meal-planner
- **Home Manager**: https://github.com/srummel/home-manager

## Documentation

- [Architecture](docs/ARCHITECTURE.md) - System design
- [Deployment](docs/DEPLOYMENT.md) - Deployment guide
- [Changelog](./CHANGELOG.md) - Version history

---

[Platform Documentation](../../../docs/) | [Product Overview](../../../docs/products/vehicle-manager.md)
