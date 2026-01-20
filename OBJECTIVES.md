# Vehicle Manager - Objectives & Requirements

## Overview

Vehicle Manager is an asset tracking module for comprehensive vehicle maintenance, expense tracking, and service history management across multiple vehicles.

## Mission

Extend vehicle life and reduce ownership costs through intelligent maintenance tracking, timely service reminders, and comprehensive expense analytics.

## Objectives

### Primary Objectives

1. **Maintenance Tracking**
   - Complete service history
   - Maintenance type categorization
   - Mileage-based tracking
   - Service provider records

2. **Expense Management**
   - Track all vehicle-related costs
   - Fuel expense logging
   - Maintenance cost history
   - Cost-per-mile calculations

3. **Service Reminders**
   - Mileage-based reminders
   - Date-based reminders
   - Customizable service intervals
   - Notification preferences

4. **Multi-Vehicle Support**
   - Manage multiple vehicles
   - Per-vehicle analytics
   - Fleet overview for households

### Secondary Objectives

1. **Fuel Tracking**
   - Fill-up logging
   - MPG calculations
   - Fuel efficiency trends
   - Cost-per-gallon tracking

2. **Document Storage**
   - Registration documents
   - Insurance cards
   - Service receipts
   - Manuals

## Functional Requirements

### FR-1: Vehicle Management
- **FR-1.1**: Add vehicles with make, model, year, VIN
- **FR-1.2**: Track current mileage
- **FR-1.3**: Store license plate and registration info
- **FR-1.4**: Set service intervals
- **FR-1.5**: Delete/archive vehicles

### FR-2: Maintenance Records
- **FR-2.1**: Log maintenance with date, mileage, type
- **FR-2.2**: Record service provider and cost
- **FR-2.3**: Add notes and descriptions
- **FR-2.4**: Categorize by service type
- **FR-2.5**: View maintenance history

### FR-3: Service Types
- **FR-3.1**: Oil change
- **FR-3.2**: Tire rotation
- **FR-3.3**: Brake service
- **FR-3.4**: Inspection
- **FR-3.5**: General repair
- **FR-3.6**: Custom service types

### FR-4: Fuel Tracking
- **FR-4.1**: Log fill-ups with gallons and cost
- **FR-4.2**: Record odometer reading
- **FR-4.3**: Calculate MPG per fill-up
- **FR-4.4**: Track average MPG over time
- **FR-4.5**: Cost-per-mile calculation

### FR-5: Reminders
- **FR-5.1**: Define service intervals (miles or time)
- **FR-5.2**: Track last service date/mileage
- **FR-5.3**: Calculate next due
- **FR-5.4**: Send notifications
- **FR-5.5**: Snooze or complete reminders

### FR-6: Statistics
- **FR-6.1**: Total maintenance cost per vehicle
- **FR-6.2**: Total fuel cost
- **FR-6.3**: Average MPG
- **FR-6.4**: Cost-per-mile
- **FR-6.5**: Service frequency analysis

## Non-Functional Requirements

### Performance
- Vehicle operations: < 200ms
- Statistics calculation: < 500ms
- History retrieval: < 1 second

### Availability
- 99.9% API uptime
- Offline access to vehicle data
- Background sync

### Security
- Private vehicle data
- Secure VIN storage
- HTTPS only

## Integration Points

### Artemis Integration
- Provide: Vehicle data, maintenance schedules, expenses
- Consume: Calendar events, unified expenses

### Home Manager Integration
- Shared maintenance calendar
- Combined asset overview
- Unified expense tracking

### External Integrations (Planned)
- OBD-II device connectivity
- Service provider databases
- Parts pricing APIs
- Insurance integrations

## Maintenance Types

| Type | Description | Typical Interval |
|------|-------------|------------------|
| Oil Change | Engine oil and filter | 5,000-7,500 miles |
| Tire Rotation | Rotate tire positions | 5,000-7,500 miles |
| Brake Service | Pads, rotors, fluid | 25,000-50,000 miles |
| Inspection | Safety/emissions | Annual |
| Air Filter | Engine air filter | 15,000-30,000 miles |
| Transmission | Fluid change | 30,000-60,000 miles |

## Success Criteria

### MVP Criteria
- [x] Vehicle profile management
- [x] Maintenance logging
- [x] Fuel tracking
- [x] Statistics dashboard
- [ ] Database persistence
- [ ] Service reminders

### Success Metrics
- Vehicles with 6+ months history: >50%
- Maintenance records per vehicle: >5
- Fuel log adoption: >60%
- 30-day retention: >50%

## Technology Stack

| Component | Technology |
|-----------|------------|
| Frontend | Flutter/Dart |
| Backend | Python 3.11+, FastAPI |
| Database | PostgreSQL (planned) |
| Deployment | AWS ECS Fargate |
| Port | 8030 |

## Development Status

**Current Phase**: Active Development (MVP)

### Implemented
- Vehicle management (mock data)
- Maintenance logging
- Fuel tracking
- Statistics dashboard
- Standard middleware

### In Progress
- Database persistence
- Vehicle CRUD operations
- Service reminders

### Planned
- Document storage
- OBD-II integration
- Parts database
- Insurance tracking

## Related Documentation

- [Architecture](docs/ARCHITECTURE.md)
- [Deployment](docs/DEPLOYMENT.md)
- [Platform Vision](../../../docs/VISION.md)

---

[Back to Vehicle Manager](./README.md) | [Platform Documentation](../../../docs/)
