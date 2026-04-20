# Vehicle Manager — Feature Traceability Matrix

Maps each user-facing feature from OBJECTIVES.md through specification, tests, implementation, and release verification.

---

## Traceability Chain

```
OBJECTIVES.md (product description)
    → docs/SPECIFICATION.md / docs/ARCHITECTURE.md (specification)
    → docs/WORKFLOWS.md (primary user journeys and screen map)
        → frontend/app/vehicle_app/test/unit_tests/ — service unit tests
        → frontend/app/vehicle_app/test/widget_tests/ — widget tests
        → frontend/app/vehicle_app/test/integration_tests/ — navigation tests
        → frontend/app/vehicle_app/integration_test/app_test.dart — end-to-end workflow tests
            → Source implementation
                → docs/DEPLOYMENT.md smoke test (release gate)
```

---

## Development Status Note

Vehicle Manager is at MVP stage. Backend serves mock data (in-memory, read-only, port 8030). Frontend has vehicle list, detail, maintenance, and fuel tabs. Database persistence and reminders are in progress.

---

## FR-1 · Vehicle Management

| ID | Feature | Product Spec | Tests | Implementation | Release Gate |
|----|---------|-------------|-------|----------------|--------------|
| FR-1.1–1.3 | View vehicles (make, model, year, mileage, plate) | OBJECTIVES.md FR-1.1–1.3 | `vehicle_manager_screen_test` — "loading state displays progress indicator", "error state displays error message" · `vehicle_card_test` · `navigation_test` — "navigates from VehicleManagerScreen to VehicleDetailScreen when vehicle card is tapped", "displays vehicle name in detail screen app bar" | `frontend/packages/vehicle_ui/lib/screens/vehicle_manager_screen.dart` · `frontend/packages/vehicle_ui/lib/ui_components/vehicle_card.dart` · `frontend/packages/vehicle_ui/lib/services/vehicle_api_service.dart` | Vehicle list loads |
| FR-1.4 | Set service intervals | OBJECTIVES.md FR-1.4 | None — gap | `frontend/packages/vehicle_ui/lib/services/vehicle_api_service.dart` (`getMaintenanceSchedule`) | — |
| FR-1.5 | Delete/archive vehicles | OBJECTIVES.md FR-1.5 | None — gap (backend read-only) | Planned | — |

---

## FR-2 · Maintenance Records

| ID | Feature | Product Spec | Tests | Implementation | Release Gate |
|----|---------|-------------|-------|----------------|--------------|
| FR-2.1–2.5 | View maintenance history (date, mileage, type, provider, cost, notes) | OBJECTIVES.md FR-2.1–2.5 | `maintenance_card_test` · `vehicle_detail_screen_test` — "switches between Maintenance and Fuel tabs on detail screen" | `frontend/packages/vehicle_ui/lib/ui_components/maintenance_card.dart` · `frontend/packages/vehicle_ui/lib/screens/vehicle_manager_screen.dart` · `frontend/packages/vehicle_ui/lib/services/vehicle_api_service.dart` (`getMaintenanceRecords`) | Maintenance records display |

---

## FR-3 · Service Types

| ID | Feature | Product Spec | Tests | Implementation | Release Gate |
|----|---------|-------------|-------|----------------|--------------|
| FR-3.1–3.6 | Supported service type categories (oil, tires, brakes, inspection, repair, custom) | OBJECTIVES.md FR-3.1–3.6 | `maintenance_card_test` | `frontend/packages/vehicle_ui/lib/ui_components/maintenance_card.dart` | — |

---

## FR-4 · Fuel Tracking

| ID | Feature | Product Spec | Tests | Implementation | Release Gate |
|----|---------|-------------|-------|----------------|--------------|
| FR-4.1–4.5 | View fuel records (gallons, cost, odometer, MPG, cost-per-mile) | OBJECTIVES.md FR-4.1–4.5 | `fuel_card_test` · `vehicle_detail_screen_test` — "switches between Maintenance and Fuel tabs on detail screen" | `frontend/packages/vehicle_ui/lib/ui_components/fuel_card.dart` · `frontend/packages/vehicle_ui/lib/services/vehicle_api_service.dart` (`getFuelRecords`) | Fuel records display |

---

## FR-5 · Reminders

| ID | Feature | Product Spec | Tests | Implementation | Release Gate |
|----|---------|-------------|-------|----------------|--------------|
| FR-5.1–5.5 | Service reminders (mileage/date based, next due, snooze) | OBJECTIVES.md FR-5.1–5.5 | None — gap (planned) | `frontend/packages/vehicle_ui/lib/services/vehicle_api_service.dart` (`getMaintenanceSchedule`) | — |

---

## FR-6 · Statistics

| ID | Feature | Product Spec | Tests | Implementation | Release Gate |
|----|---------|-------------|-------|----------------|--------------|
| FR-6.1–6.5 | Per-vehicle stats (total maintenance cost, fuel cost, avg MPG, cost-per-mile, service frequency) | OBJECTIVES.md FR-6.1–6.5 | None — gap | `frontend/packages/vehicle_ui/lib/services/vehicle_api_service.dart` (`getVehicleStats`, `getUserSummary`) | — |

---

## API Service Coverage

`vehicle_api_service_test` verifies the service contract (not data):

| Method | Test |
|--------|------|
| `getVehicles` | "getVehicles returns Future<Map>" · "has getVehicles method" · "uses custom base URL" · "uses default localhost URL" |
| `getVehicle` | "getVehicle returns Future<Map>" · "has getVehicle method" |
| `getMaintenanceRecords` | "getMaintenanceRecords returns Future<Map>" · "has getMaintenanceRecords method" |
| `getFuelRecords` | "getFuelRecords returns Future<Map>" · "has getFuelRecords method" |
| `getMaintenanceSchedule` | "has getMaintenanceSchedule method" |
| `getVehicleStats` | "has getVehicleStats method" |
| `getUserSummary` | "has getUserSummary method" |

---

## Navigation / Integration Test Coverage

`navigation_test` covers:
- Navigate VehicleManagerScreen → VehicleDetailScreen on card tap
- Navigate back from VehicleDetailScreen
- Maintains state when navigating back
- Switches between Maintenance and Fuel tabs
- Displays vehicle name in detail screen AppBar
- Refresh button on main screen reloads data
- Pull to refresh reloads data
- Error state displays error message
- Loading state displays progress indicator
- Tab controller maintains state during navigation
- Swiping between tabs works
- Handles no-vehicles state
- Correctly disposes resources on navigation

---

## Coverage Summary

| FR Group | Sub-features | Tests | Gaps |
|----------|-------------|-------|------|
| FR-1 Vehicle Management | 5 | Widget + navigation + service | CRUD (backend read-only); archive untested |
| FR-2 Maintenance Records | 5 | Widget + service contract | Create/edit maintenance — in progress |
| FR-3 Service Types | 6 | maintenance_card_test | Type filtering untested |
| FR-4 Fuel Tracking | 5 | fuel_card_test + service | Create fuel log — in progress |
| FR-5 Reminders | 5 | None | Entire group — planned |
| FR-6 Statistics | 5 | None | Stats display untested |

> **Priority gaps**: Add `vehicle_stats_screen_test`; add `reminder_test` once reminder logic is implemented; add backend pytest tests for mock API endpoints; add tests for create/edit vehicle and maintenance log once CRUD is implemented.

## Integration Test Coverage

`frontend/app/vehicle_app/integration_test/app_test.dart` covers:
- App loads without crashing
- App renders a Scaffold
- Theme is applied
- App shows login screen or vehicle list on launch
- Login screen has email and password fields
- Auth check does not crash
- App title Vehicle Manager is displayed
- Refresh button present on vehicle list
- Vehicle Management section header present
- Refresh triggers reload without crashing
- Tapping a vehicle card navigates to detail screen
- Vehicle detail screen has Maintenance tab
- Vehicle detail screen has Fuel tab
- Switching between Maintenance and Fuel tabs works
- Back navigation returns to vehicle list
- Pull to refresh gesture does not crash
- App handles backend unavailability gracefully
- Multiple refresh taps do not crash

## Workflow Documentation

Primary user journeys documented in `docs/WORKFLOWS.md`:
- Workflow 1: Authentication (login, logout)
- Workflow 2: Vehicle Management (list, add, view detail)
- Workflow 3: Maintenance Records (view history, log service)
- Workflow 4: Fuel Tracking (view log, log fill-up)
- Workflow 5: Statistics Dashboard
- Workflow 6: Service Reminders (planned)
- Workflow 7: Multi-Vehicle Household
- Workflow 8: Tab Switching
- Screen / Route Map
