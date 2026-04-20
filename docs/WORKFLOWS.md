# Vehicle Manager — Primary Workflows

Documents the main user-facing journeys through the Vehicle Manager app.

---

## Navigation Structure

App opens to **AuthWrapper**:
- If authenticated → **VehicleManagerScreen** (vehicle list)
- If not authenticated → **LoginScreen**

**VehicleManagerScreen** lists all vehicles. Tapping a vehicle opens **VehicleDetailScreen** with tabbed navigation:
- **Maintenance** tab — service history
- **Fuel** tab — fill-up log

---

## 1. Authentication

### Login
1. Open app → **LoginScreen**
2. Enter email and password → tap **Log In**
3. JWT stored → lands on **VehicleManagerScreen**

### Logout
**Entry:** VehicleManagerScreen → profile / settings → **Logout**

---

## 2. Vehicle Management (Core Workflow)

### View Vehicle List
**Entry:** VehicleManagerScreen

- Each vehicle card shows: make, model, year, current mileage, license plate
- Pull-to-refresh reloads the list
- Refresh icon in AppBar also triggers reload

### Add a Vehicle (Planned — CRUD in progress)
**Entry:** VehicleManagerScreen → "+"

1. Enter: make, model, year
2. Enter: VIN, license plate, registration state
3. Enter: current odometer reading
4. Set service intervals (e.g. oil change every 5,000 miles)
5. Save → vehicle appears in list

### View Vehicle Detail
**Entry:** VehicleManagerScreen → tap a vehicle card

- **VehicleDetailScreen** AppBar shows vehicle name
- Statistics summary at top: total maintenance cost, avg MPG, cost-per-mile
- Tab bar: Maintenance | Fuel

---

## 3. Maintenance Records

### View Maintenance History
**Entry:** VehicleDetailScreen → **Maintenance** tab

- Chronological list of service records
- Each card shows: date, mileage, service type, provider, cost, notes

### Log Maintenance (Planned — CRUD in progress)
**Entry:** Maintenance tab → "+"

1. Select service type: Oil Change, Tire Rotation, Brake Service, Inspection, General Repair, Custom
2. Enter: date, odometer reading
3. Enter: service provider name and cost
4. Add notes
5. Save → record appears in history; stats recalculate

### Service Types

| Type | Typical Interval |
|------|-----------------|
| Oil Change | 5,000–7,500 miles |
| Tire Rotation | 5,000–7,500 miles |
| Brake Service | 25,000–50,000 miles |
| Inspection | Annual |
| General Repair | As needed |
| Custom | User-defined |

---

## 4. Fuel Tracking

### View Fuel Log
**Entry:** VehicleDetailScreen → **Fuel** tab

- Chronological list of fill-ups
- Each card shows: date, gallons, cost, odometer, MPG calculated for that fill-up

### Log a Fill-Up (Planned — CRUD in progress)
**Entry:** Fuel tab → "+"

1. Enter: date, odometer reading
2. Enter: gallons pumped
3. Enter: total cost (or price per gallon)
4. Save → MPG calculated from distance since last fill-up; log updated

---

## 5. Statistics Dashboard

Displayed at the top of **VehicleDetailScreen**:

| Metric | Calculation |
|--------|------------|
| Total maintenance cost | Sum of all service record costs |
| Total fuel cost | Sum of all fill-up costs |
| Average MPG | Rolling average across all fill-ups |
| Cost per mile | (maintenance + fuel) ÷ total miles driven |
| Service frequency | Average miles between service visits |

---

## 6. Service Reminders (Planned)

**Entry:** Vehicle Detail → **Reminders** section

1. Define interval: e.g. "Oil change every 5,000 miles or 6 months"
2. System calculates next due date based on last service + interval
3. Reminder appears on VehicleManagerScreen when due within 500 miles or 30 days
4. Snooze or mark as completed

---

## 7. Multi-Vehicle Household

- Add multiple vehicles to the same account
- VehicleManagerScreen shows all vehicles with summary stats
- Switch between vehicles via the vehicle list

---

## 8. Tab Switching

- **Maintenance** and **Fuel** tabs maintain independent scroll state
- Swiping left/right between tabs works alongside tap navigation
- Tab controller state preserved during navigation back from child screens

---

## 9. Screen / Route Map

| Screen | Purpose |
|--------|---------|
| LoginScreen | Email/password authentication |
| VehicleManagerScreen | Vehicle list with stats cards |
| VehicleDetailScreen | Per-vehicle detail with Maintenance + Fuel tabs |
| MaintenanceRecordFormScreen | Log a new service record (planned) |
| FuelLogFormScreen | Log a fill-up (planned) |
| VehicleFormScreen | Add/edit a vehicle (planned) |
| RemindersScreen | View and manage service reminders (planned) |

---

## 10. Typical Workflow

```
VehicleManagerScreen
    → See list of 2 vehicles
    → Tap "2021 Toyota Camry"
        → VehicleDetailScreen shows stats
        → Maintenance tab: last oil change 3 months ago
        → Fuel tab: last fill-up was 32 MPG
    → Navigate back → VehicleManagerScreen
    → Pull to refresh → stats updated
```
