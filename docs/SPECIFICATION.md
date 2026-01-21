---
module: vehicle-manager
version: 1.0.0
status: draft
last_updated: 2026-01-20
---

# Vehicle Manager Specification

## Overview

The Vehicle Manager module provides comprehensive vehicle management capabilities including maintenance tracking, fuel logging, and service scheduling. It enables users to manage multiple vehicles, track maintenance history, log fuel fill-ups with MPG calculations, monitor maintenance schedules, and view cost statistics. The module consists of a FastAPI backend (port 8030) with mock data and a Flutter web frontend with Material Design 3 styling.

## Authentication

This module uses the shared AWS Amplify authentication system. See [Authentication Architecture](../../../../docs/architecture/AUTHENTICATION.md) for complete details.

### Authentication Modes

| Mode | Description |
|------|-------------|
| Artemis-Integrated | User authenticates via Artemis, gains access to all permitted modules |
| Standalone | User authenticates directly in Vehicle Manager app |

### Module Access

- **Module ID**: `vehicle-manager`
- **Artemis Users**: Full access when `artemis_access: true`
- **Standalone Users**: Access when `vehicle-manager` in `module_access` list

### Login Screen

Uses shared `auth_ui` package with identical UI to all other modules:
- Email/password authentication
- Google Sign-In
- Apple Sign-In
- Email verification flow
- Password reset flow

### API Authentication

All API endpoints require JWT Bearer token from AWS Cognito:
```http
Authorization: Bearer <access_token>
```

Backend validates tokens using AWS Cognito SDK and checks module access permissions.

## Design System

This module uses the shared Artemis Design System. See [Design System](../../../../docs/architecture/DESIGN_SYSTEM.md) for complete specifications.

### Design Principles

All UI components follow the shared design system to ensure visual consistency across the Artemis ecosystem:

- **Colors**: Rummel Blue primary (`#1E88E5`), Teal secondary (`#26A69A`)
- **Typography**: Material 3 type scale with system fonts
- **Spacing**: Consistent 4dp base unit scale (xs: 4dp, sm: 8dp, md: 16dp, lg: 24dp)
- **Components**: Shared button, card, input, and navigation styles

### Module-Specific Colors

| Element | Color | Token | Usage |
|---------|-------|-------|-------|
| Maintenance Due | `#F57C00` | `warning` | Service coming due soon |
| Maintenance Overdue | `#D32F2F` | `error` | Service past due |
| Up to Date | `#388E3C` | `success` | All services current |
| Fuel Cost | `#1E88E5` | `primary500` | Fuel expense displays |
| Maintenance Cost | `#7B1FA2` | Purple | Maintenance expense displays |

### Maintenance Status Colors

| Status | Color | Token | Condition |
|--------|-------|-------|-----------|
| Upcoming | `#388E3C` | `success` | > 1000 miles until due |
| Due | `#F57C00` | `warning` | Within 1000 miles of due |
| Overdue | `#D32F2F` | `error` | Past due mileage |

### Key Components

| Component | Specification |
|-----------|---------------|
| VehicleCard | Card with vehicle image placeholder, make/model, mileage, quick stats |
| MaintenanceCard | Card with service type icon, date, cost, status badge |
| FuelCard | Card with fuel type, gallons, cost, calculated MPG |
| ScheduleItem | List tile with service type, due mileage, status indicator |
| StatsCard | Summary with fuel totals, maintenance totals, average MPG |
| StatusBadge | Chip with semantic color based on status |

### Service Type Icons

| Service | Icon |
|---------|------|
| Oil Change | `oil_barrel` |
| Tire Rotation | `tire_repair` |
| Brake Service | `disc_full` |
| Inspection | `fact_check` |
| Battery | `battery_charging_full` |
| Transmission | `settings` |
| General Repair | `build` |

### Screen Layouts

All screens follow responsive breakpoints from the shared design system:
- Mobile (< 600dp): Single vehicle view with tabbed sections
- Tablet (600-839dp): Vehicle list sidebar with detail panel
- Desktop (>= 840dp): Multi-vehicle dashboard with expandable details

## Data Models

### Vehicle

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | String | PK, unique | Unique identifier |
| make | String | Required | Vehicle manufacturer |
| model | String | Required | Vehicle model name |
| year | int | Required, 1900-2100 | Model year |
| vin | String? | Optional, 17 chars | Vehicle Identification Number |
| license_plate | String? | Optional | License plate number |
| current_mileage | int | Required, >= 0 | Current odometer reading |
| color | String? | Optional | Vehicle color |

**Relationships:**
- Vehicle has many MaintenanceRecords
- Vehicle has many FuelRecords
- Vehicle has many MaintenanceSchedules

**Indexes (Planned):**
- user_id (for user-scoped queries)
- make, model (for filtering)

**JSON Serialization:**
```json
{
  "id": "v1",
  "make": "Toyota",
  "model": "Camry",
  "year": 2020,
  "vin": "1HGBH41JXMN109186",
  "license_plate": "ABC-1234",
  "current_mileage": 45000,
  "color": "Silver"
}
```

### MaintenanceRecord

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | String | PK, unique | Unique identifier |
| vehicle_id | String | FK to Vehicle | Parent vehicle |
| date | String | Required, ISO date | Service date |
| type | String | Required, enum | Type of service |
| mileage | int | Required, >= 0 | Odometer at service |
| cost | float? | Optional, >= 0 | Service cost |
| description | String? | Optional | Service details |
| next_due_mileage | int? | Optional | Next service mileage |
| next_due_date | String? | Optional, ISO date | Next service date |

**Service Types:**
| Type | Description |
|------|-------------|
| oil_change | Engine oil and filter replacement |
| tire_rotation | Tire position rotation |
| tire_replacement | New tire installation |
| brake_service | Brake pad/rotor service |
| inspection | Safety/emissions inspection |
| air_filter | Air filter replacement |
| transmission | Transmission service |
| battery | Battery replacement |
| coolant | Coolant flush/fill |
| spark_plugs | Spark plug replacement |
| repair | General repair |
| other | Other service |

**Relationships:**
- MaintenanceRecord belongs to Vehicle

**Indexes (Planned):**
- vehicle_id (for vehicle-scoped queries)
- date (for chronological sorting)
- type (for type filtering)

**JSON Serialization:**
```json
{
  "id": "m1",
  "vehicle_id": "v1",
  "date": "2025-10-15",
  "type": "oil_change",
  "mileage": 42000,
  "cost": 45.99,
  "description": "Synthetic oil change and filter replacement",
  "next_due_mileage": 47000,
  "next_due_date": "2026-04-15"
}
```

### FuelRecord

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | String | PK, unique | Unique identifier |
| vehicle_id | String | FK to Vehicle | Parent vehicle |
| date | String | Required, ISO date | Fill-up date |
| mileage | int | Required, >= 0 | Odometer at fill-up |
| gallons | float | Required, > 0 | Gallons purchased |
| cost | float | Required, >= 0 | Total cost |
| price_per_gallon | float? | Calculated/input | Price per gallon |
| fuel_type | String | Default: regular | Fuel grade |
| mpg | float? | Calculated | Miles per gallon |

**Fuel Types:**
| Type | Description |
|------|-------------|
| regular | Regular unleaded (87) |
| midgrade | Mid-grade (89) |
| premium | Premium (91-93) |
| diesel | Diesel fuel |
| e85 | Ethanol E85 |
| electric | Electric charging |

**Computed Properties:**
- `price_per_gallon`: cost / gallons (if not provided)
- `mpg`: (current_mileage - previous_mileage) / gallons

**Relationships:**
- FuelRecord belongs to Vehicle

**Indexes (Planned):**
- vehicle_id (for vehicle-scoped queries)
- date (for chronological sorting)

**JSON Serialization:**
```json
{
  "id": "f1",
  "vehicle_id": "v1",
  "date": "2025-11-18",
  "mileage": 45000,
  "gallons": 12.5,
  "cost": 43.75,
  "price_per_gallon": 3.50,
  "fuel_type": "regular",
  "mpg": 28.4
}
```

### MaintenanceSchedule

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| id | String | PK, unique | Unique identifier |
| vehicle_id | String | FK to Vehicle | Parent vehicle |
| service_type | String | Required | Type of scheduled service |
| interval_miles | int | Required, > 0 | Miles between services |
| last_service_mileage | int | Required | Mileage at last service |
| next_due_mileage | int | Calculated | When service is due |
| status | String | Calculated | upcoming/due/overdue |

**Status Calculation:**
```
if current_mileage < next_due_mileage - 1000: status = "upcoming"
if current_mileage >= next_due_mileage - 1000 and < next_due_mileage + 500: status = "due"
if current_mileage >= next_due_mileage + 500: status = "overdue"
```

**Relationships:**
- MaintenanceSchedule belongs to Vehicle

**JSON Serialization:**
```json
{
  "id": "s1",
  "vehicle_id": "v1",
  "service_type": "Oil Change",
  "interval_miles": 5000,
  "last_service_mileage": 42000,
  "next_due_mileage": 47000,
  "status": "upcoming"
}
```

### VehicleStats

| Field | Type | Description |
|-------|------|-------------|
| vehicle_id | String | Vehicle identifier |
| fuel.total_cost | float | Total fuel spending |
| fuel.total_gallons | float | Total gallons purchased |
| fuel.average_mpg | float | Average fuel efficiency |
| fuel.fill_ups | int | Number of fill-ups |
| maintenance.total_cost | float | Total maintenance spending |
| maintenance.services | int | Number of services |
| maintenance.last_service_date | String | Most recent service |

**JSON Serialization:**
```json
{
  "vehicle_id": "v1",
  "fuel": {
    "total_cost": 127.75,
    "total_gallons": 36.5,
    "average_mpg": 28.8,
    "fill_ups": 3
  },
  "maintenance": {
    "total_cost": 380.48,
    "services": 4,
    "last_service_date": "2025-10-15"
  }
}
```

### UserSummary

| Field | Type | Description |
|-------|------|-------------|
| user_id | String | User identifier |
| total_vehicles | int | Number of vehicles |
| total_fuel_cost | float | Combined fuel spending |
| total_maintenance_cost | float | Combined maintenance |
| total_cost | float | Grand total spending |

**JSON Serialization:**
```json
{
  "user_id": "user-123",
  "total_vehicles": 2,
  "total_fuel_cost": 255.50,
  "total_maintenance_cost": 760.96,
  "total_cost": 1016.46
}
```

## Use Cases

### UC-001: Add Vehicle

**Actor:** User

**Preconditions:**
- User is authenticated

**Flow:**
1. User opens add vehicle form
2. User enters make, model, year, mileage
3. User optionally adds VIN, license plate, color
4. User saves vehicle
5. System creates vehicle record

**Postconditions:**
- Vehicle added to user's garage

**Acceptance Criteria:**
- [ ] Vehicle appears in vehicle list
- [ ] All fields saved correctly
- [ ] VIN validated if provided
- [ ] Year within reasonable range

### UC-002: Log Maintenance

**Actor:** User

**Preconditions:**
- Vehicle exists

**Flow:**
1. User selects vehicle
2. User opens maintenance log form
3. User enters date, type, mileage, cost
4. User optionally sets next due date/mileage
5. User saves record
6. System creates maintenance record
7. System updates maintenance schedule

**Postconditions:**
- Maintenance record created
- Schedule updated if applicable
- Stats reflect new cost

**Acceptance Criteria:**
- [ ] Record linked to correct vehicle
- [ ] Cost added to totals
- [ ] Schedule status recalculated
- [ ] Mileage validated (>= current)

### UC-003: Log Fuel Fill-up

**Actor:** User

**Preconditions:**
- Vehicle exists

**Flow:**
1. User selects vehicle
2. User opens fuel log form
3. User enters date, mileage, gallons, cost
4. System calculates MPG from previous fill-up
5. User saves record
6. System creates fuel record

**Postconditions:**
- Fuel record created
- MPG calculated
- Stats updated

**Acceptance Criteria:**
- [ ] MPG calculated correctly
- [ ] Cost per gallon derived
- [ ] Fuel totals updated
- [ ] Average MPG recalculated

### UC-004: View Maintenance Schedule

**Actor:** User

**Preconditions:**
- Vehicle exists with maintenance history

**Flow:**
1. User selects vehicle
2. User views maintenance schedule
3. System retrieves schedule items
4. System calculates status for each item
5. System displays schedule with status indicators

**Postconditions:**
- Schedule displayed with due status

**Acceptance Criteria:**
- [ ] Items sorted by urgency
- [ ] Status indicators visible (color-coded)
- [ ] Due mileage shown
- [ ] Overdue items highlighted

### UC-005: View Vehicle Statistics

**Actor:** User

**Preconditions:**
- Vehicle has fuel and/or maintenance records

**Flow:**
1. User selects vehicle
2. User navigates to statistics view
3. System aggregates fuel records
4. System aggregates maintenance records
5. System displays statistics dashboard

**Postconditions:**
- Statistics displayed

**Acceptance Criteria:**
- [ ] Total costs shown
- [ ] Average MPG calculated
- [ ] Cost breakdown by category
- [ ] Historical trends visualized

### UC-006: Set Maintenance Reminders (Planned)

**Actor:** User

**Preconditions:**
- Vehicle has maintenance schedule

**Flow:**
1. User views maintenance schedule
2. User enables reminder for service type
3. User sets reminder threshold (miles before due)
4. System stores reminder preference
5. System sends notification when threshold reached

**Postconditions:**
- Reminder configured

**Acceptance Criteria:**
- [ ] Reminder preference saved
- [ ] Notification sent at threshold
- [ ] Can disable reminder
- [ ] Multiple reminders per vehicle

## UI Workflows

### Screen: Vehicle Manager Dashboard

**Purpose:** Overview of all vehicles and quick stats

**Entry Points:**
- Main app navigation
- Dashboard widget

**Components:**
- VehicleList: All user vehicles as cards
- VehicleCard: Make/model, mileage, quick stats
- TotalSummary: Combined costs across vehicles
- QuickActions: Add vehicle, log maintenance, log fuel

**Actions:**
| Action | Trigger | Result |
|--------|---------|--------|
| Select Vehicle | Card tap | Navigate to vehicle detail |
| Add Vehicle | FAB tap | Open add vehicle form |
| View Summary | Button tap | Show cost summary |

**Navigation:**
- Vehicle tap → Vehicle Detail
- Add → Vehicle Editor

### Screen: Vehicle Detail

**Purpose:** Comprehensive view of single vehicle

**Entry Points:**
- Dashboard vehicle card tap

**Components:**
- VehicleHeader: Make/model/year, image placeholder
- InfoSection: VIN, plate, mileage, color
- TabBar: Maintenance, Fuel, Schedule, Stats
- MaintenanceList: Recent maintenance records
- FuelList: Recent fuel records
- ScheduleList: Upcoming services
- StatsCards: Costs, MPG, service counts

**Actions:**
| Action | Trigger | Result |
|--------|---------|--------|
| Log Maintenance | Button | Open maintenance form |
| Log Fuel | Button | Open fuel form |
| Edit Vehicle | Edit icon | Open vehicle editor |
| View Record | Record tap | Show record detail |

**Navigation:**
- Log Maintenance → Maintenance Form
- Log Fuel → Fuel Form
- Edit → Vehicle Editor
- Back → Dashboard

### Screen: Maintenance Log Form

**Purpose:** Create maintenance record

**Entry Points:**
- Vehicle detail log button
- Quick action

**Components:**
- DatePicker: Service date
- TypeSelector: Service type dropdown
- MileageInput: Odometer reading
- CostInput: Service cost
- DescriptionField: Service notes
- NextDueInputs: Optional next service mileage/date
- SaveButton: Confirm entry

**Actions:**
| Action | Trigger | Result |
|--------|---------|--------|
| Save | Button tap | Create record, return |
| Cancel | Back/cancel | Discard entry |

**Navigation:**
- Save → Vehicle Detail (with new record)

### Screen: Fuel Log Form

**Purpose:** Create fuel fill-up record

**Entry Points:**
- Vehicle detail log button
- Quick action

**Components:**
- DatePicker: Fill-up date
- MileageInput: Odometer reading
- GallonsInput: Gallons purchased
- CostInput: Total cost
- FuelTypeSelector: Regular/premium/diesel
- CalculatedFields: Price/gallon, MPG (auto)
- SaveButton: Confirm entry

**Actions:**
| Action | Trigger | Result |
|--------|---------|--------|
| Save | Button tap | Create record, return |
| Calculate MPG | Auto | Show calculated MPG |

**Navigation:**
- Save → Vehicle Detail (with new record)

### Screen: Maintenance Schedule

**Purpose:** View and manage upcoming maintenance

**Entry Points:**
- Vehicle detail schedule tab

**Components:**
- ScheduleList: All scheduled services
- ScheduleCard: Service type, interval, due mileage, status
- StatusBadge: Color-coded (green/yellow/red)
- AddScheduleButton: Create custom schedule
- ReminderToggle: Enable/disable reminders

**Actions:**
| Action | Trigger | Result |
|--------|---------|--------|
| Mark Complete | Button | Log as completed |
| Edit Schedule | Card tap | Modify interval |
| Add Schedule | Button | Create new schedule |

**Navigation:**
- Mark Complete → Maintenance Form (prefilled)

## API Specification

### GET /health

**Description:** Health check endpoint

**Authentication:** None

**Response 200:**
```json
{"status": "ok"}
```

### GET /ready

**Description:** Readiness probe

**Authentication:** None

**Response 200:**
```json
{"status": "ready"}
```

### GET /vehicles/{user_id}

**Description:** Get all vehicles for user

**Authentication:** None (planned: JWT Bearer)

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| user_id | string | Yes | User identifier |

**Response 200:**
```json
{
  "user_id": "user-123",
  "vehicles": [
    {
      "id": "v1",
      "make": "Toyota",
      "model": "Camry",
      "year": 2020,
      "vin": "1HGBH41JXMN109186",
      "license_plate": "ABC-1234",
      "current_mileage": 45000,
      "color": "Silver"
    }
  ]
}
```

### GET /vehicles/{user_id}/{vehicle_id}

**Description:** Get specific vehicle details

**Authentication:** None (planned: JWT Bearer)

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| user_id | string | Yes | User identifier |
| vehicle_id | string | Yes | Vehicle identifier |

**Response 200:**
```json
{
  "id": "v1",
  "make": "Toyota",
  "model": "Camry",
  "year": 2020,
  ...
}
```

**Error Responses:**
| Code | Condition |
|------|-----------|
| 404 | Vehicle not found |

### GET /maintenance/{vehicle_id}

**Description:** Get all maintenance records for vehicle

**Authentication:** None (planned: JWT Bearer)

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| vehicle_id | string | Yes | Vehicle identifier |

**Response 200:**
```json
{
  "vehicle_id": "v1",
  "records": [
    {
      "id": "m1",
      "date": "2025-10-15",
      "type": "oil_change",
      "mileage": 42000,
      "cost": 45.99,
      "description": "Synthetic oil change",
      "next_due_mileage": 47000
    }
  ]
}
```

### GET /maintenance/{vehicle_id}/type/{service_type}

**Description:** Get maintenance records by type

**Authentication:** None (planned: JWT Bearer)

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| vehicle_id | string | Yes | Vehicle identifier |
| service_type | string | Yes | Service type filter |

**Response 200:**
```json
{
  "vehicle_id": "v1",
  "type": "oil_change",
  "records": [...]
}
```

### GET /fuel/{vehicle_id}

**Description:** Get fuel records for vehicle

**Authentication:** None (planned: JWT Bearer)

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| vehicle_id | string | Yes | Vehicle identifier |

**Query Parameters:**
| Name | Type | Default | Description |
|------|------|---------|-------------|
| limit | int | none | Maximum records to return |

**Response 200:**
```json
{
  "vehicle_id": "v1",
  "records": [
    {
      "id": "f1",
      "date": "2025-11-18",
      "mileage": 45000,
      "gallons": 12.5,
      "cost": 43.75,
      "price_per_gallon": 3.50,
      "fuel_type": "regular",
      "mpg": 28.4
    }
  ]
}
```

### GET /schedule/{vehicle_id}

**Description:** Get maintenance schedule for vehicle

**Authentication:** None (planned: JWT Bearer)

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| vehicle_id | string | Yes | Vehicle identifier |

**Response 200:**
```json
{
  "vehicle_id": "v1",
  "current_mileage": 45000,
  "schedules": [
    {
      "id": "s1",
      "service_type": "Oil Change",
      "interval_miles": 5000,
      "last_service_mileage": 42000,
      "next_due_mileage": 47000,
      "status": "upcoming"
    }
  ]
}
```

### GET /stats/{vehicle_id}

**Description:** Get statistics for vehicle

**Authentication:** None (planned: JWT Bearer)

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| vehicle_id | string | Yes | Vehicle identifier |

**Response 200:**
```json
{
  "vehicle_id": "v1",
  "fuel": {
    "total_cost": 127.75,
    "total_gallons": 36.5,
    "average_mpg": 28.8,
    "fill_ups": 3
  },
  "maintenance": {
    "total_cost": 380.48,
    "services": 4,
    "last_service_date": "2025-10-15"
  }
}
```

### GET /summary/{user_id}

**Description:** Get summary for all user vehicles

**Authentication:** None (planned: JWT Bearer)

**Path Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| user_id | string | Yes | User identifier |

**Response 200:**
```json
{
  "user_id": "user-123",
  "total_vehicles": 2,
  "total_fuel_cost": 255.50,
  "total_maintenance_cost": 760.96,
  "total_cost": 1016.46
}
```

### POST /vehicles/{user_id} (Planned)

**Description:** Add a new vehicle

**Authentication:** Required (JWT Bearer)

**Request Body:**
```json
{
  "make": "string - required",
  "model": "string - required",
  "year": "int - required",
  "current_mileage": "int - required",
  "vin": "string - optional",
  "license_plate": "string - optional",
  "color": "string - optional"
}
```

### POST /maintenance/{vehicle_id} (Planned)

**Description:** Log maintenance record

**Authentication:** Required (JWT Bearer)

**Request Body:**
```json
{
  "date": "string - required (ISO date)",
  "type": "string - required",
  "mileage": "int - required",
  "cost": "float - optional",
  "description": "string - optional",
  "next_due_mileage": "int - optional",
  "next_due_date": "string - optional"
}
```

### POST /fuel/{vehicle_id} (Planned)

**Description:** Log fuel fill-up

**Authentication:** Required (JWT Bearer)

**Request Body:**
```json
{
  "date": "string - required (ISO date)",
  "mileage": "int - required",
  "gallons": "float - required",
  "cost": "float - required",
  "fuel_type": "string - optional (default: regular)"
}
```

## Implementation Status

### Data Models

| Model | Status | Notes |
|-------|--------|-------|
| Vehicle | ✅ Implemented | Pydantic model |
| MaintenanceRecord | ✅ Implemented | Pydantic model |
| FuelRecord | ✅ Implemented | Pydantic model |
| MaintenanceSchedule | ✅ Implemented | Pydantic model |
| VehicleStats | ✅ Implemented | Computed response |
| UserSummary | ✅ Implemented | Aggregated response |

### API Endpoints

| Endpoint | Status | Notes |
|----------|--------|-------|
| GET /health | ✅ Implemented | Health check |
| GET /ready | ✅ Implemented | Readiness probe |
| GET /vehicles/{user_id} | ✅ Implemented | Returns 2 mock vehicles |
| GET /vehicles/{user_id}/{vehicle_id} | ✅ Implemented | Single vehicle |
| GET /maintenance/{vehicle_id} | ✅ Implemented | 4 mock records |
| GET /maintenance/{vehicle_id}/type/{type} | ✅ Implemented | Type filter |
| GET /fuel/{vehicle_id} | ✅ Implemented | 3 mock records |
| GET /schedule/{vehicle_id} | ✅ Implemented | 3 schedule items |
| GET /stats/{vehicle_id} | ✅ Implemented | Aggregated stats |
| GET /summary/{user_id} | ✅ Implemented | All vehicles summary |
| POST /vehicles | ⬜ Planned | Add vehicle |
| POST /maintenance | ⬜ Planned | Log maintenance |
| POST /fuel | ⬜ Planned | Log fuel |
| PUT /vehicles/{id} | ⬜ Planned | Update vehicle |
| DELETE /vehicles/{id} | ⬜ Planned | Remove vehicle |

### UI Screens

| Screen | Status | Notes |
|--------|--------|-------|
| Login | ⬜ Planned | Uses shared auth_ui package |
| Register | ⬜ Planned | Uses shared auth_ui package |
| Vehicle Manager Dashboard | ✅ Implemented | Overview screen |
| Vehicle Detail | ⬜ Planned | Tabbed detail view |
| Maintenance Form | ⬜ Planned | Log maintenance |
| Fuel Form | ⬜ Planned | Log fuel |
| Vehicle Editor | ⬜ Planned | Add/edit vehicle |
| Maintenance Schedule | ⬜ Planned | Schedule view |
| Statistics Dashboard | ⬜ Planned | Detailed analytics |

### Authentication

| Component | Status | Notes |
|-----------|--------|-------|
| AWS Amplify Integration | ⬜ Planned | Shared Cognito User Pool |
| Shared auth_ui Package | ⬜ Planned | Login/register screens |
| Token Validation | ⬜ Planned | Backend JWT verification |
| Module Access Control | ⬜ Planned | Cognito custom attributes |

### Frontend Services

| Service | Status | Notes |
|---------|--------|-------|
| VehicleApiService | ✅ Implemented | HTTP client |
| getVehicles() | ✅ Implemented | Fetches vehicles |
| getVehicle() | ✅ Implemented | Single vehicle |
| getMaintenanceRecords() | ✅ Implemented | Maintenance list |
| getFuelRecords() | ✅ Implemented | Fuel list |
| getMaintenanceSchedule() | ✅ Implemented | Schedule data |
| getVehicleStats() | ✅ Implemented | Statistics |
| getUserSummary() | ✅ Implemented | Summary data |

### UI Components

| Component | Status | Notes |
|-----------|--------|-------|
| VehicleCard | ✅ Implemented | Vehicle summary |
| MaintenanceCard | ✅ Implemented | Record display |
| FuelCard | ✅ Implemented | Record display |

**Legend:** ✅ Implemented | 🚧 Partial | ⬜ Planned

## Technical Notes

### Backend
- Framework: FastAPI
- Port: 8030
- Root Path: Configurable via ROOT_PATH env var
- Storage: In-memory mock data (no database)
- CORS: Open policy (all origins allowed)

### Frontend
- Framework: Flutter Web
- Package: frontend/packages/vehicle_ui
- State Management: StatefulWidget with setState()
- API Base URL: Configurable

### Key Implementation Details
- Mock data provides 2 vehicles with complete history
- Each vehicle has 4 maintenance records, 3 fuel records
- MPG precalculated in mock data
- Schedule status dynamically calculated from current_mileage
- Statistics aggregated on each request
- All costs rounded to 2 decimal places
