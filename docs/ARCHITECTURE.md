# Vehicle Manager Architecture

## Overview

The Vehicle Manager is a Flutter application for vehicle maintenance logging and expense tracking, supported by a Python/FastAPI backend service.

## System Components

```
┌─────────────────────┐
│   Flutter App       │
│   (vehicle-manager) │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   FastAPI Service   │
│   (port 8030)       │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   PostgreSQL/SQLite │
└─────────────────────┘
```

## Frontend Architecture

### Project Structure

```
vehicle-manager/
├── lib/
│   ├── main.dart           # App entry point
│   ├── config/             # Environment configuration
│   ├── models/             # Data models
│   ├── services/           # API services
│   └── screens/            # UI screens
├── packages/               # Feature packages (if modular)
└── test/                   # Unit tests
```

### Key Components

- **Vehicle Dashboard**: Overview of all vehicles
- **Maintenance Log**: Service history and tracking
- **Expense Tracker**: Cost categorization
- **Reminder System**: Mileage-based alerts

## Backend Architecture

### Service Structure

```
services/vehicle-manager/
├── main.py                 # FastAPI app
├── routers/                # API endpoints
├── models/                 # Pydantic models
├── database.py             # Database operations
└── tests/                  # Pytest suite
```

### Key Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/vehicles` | GET/POST | Vehicle CRUD |
| `/maintenance` | GET/POST | Maintenance log CRUD |
| `/expenses` | GET/POST | Expense CRUD |
| `/reminders` | GET | Upcoming maintenance |

## Data Models

### Vehicle
- id, make, model, year
- vin, license_plate
- current_mileage

### MaintenanceRecord
- id, vehicle_id
- service_type, description
- date, mileage, cost

### Expense
- id, vehicle_id
- category (fuel, maintenance, insurance, etc.)
- amount, date, description

## Related Documentation

- [Module README](../README.md)
- [Service README](../../../../services/vehicle-manager/README.md)
- [Deployment Guide](./DEPLOYMENT.md)
- [Platform Architecture](../../../../docs/ARCHITECTURE.md)

---

[Back to Module](../) | [Platform Documentation](../../../../docs/)
