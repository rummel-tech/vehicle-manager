# Vehicle Manager Test Suite

Comprehensive test suite for the Vehicle Manager application covering UI components, navigation, and API service layer.

## Test Structure

```
test/
├── widget_tests/              # Widget tests for UI components
│   ├── vehicle_card_test.dart
│   ├── maintenance_card_test.dart
│   ├── fuel_card_test.dart
│   ├── vehicle_manager_screen_test.dart
│   └── vehicle_detail_screen_test.dart
├── unit_tests/                # Unit tests for services
│   └── vehicle_api_service_test.dart
├── integration_tests/         # Integration tests for navigation
│   └── navigation_test.dart
└── README.md                  # This file
```

## Test Coverage

### Widget Tests

#### VehicleCard (vehicle_card_test.dart)
- ✓ Displays vehicle information correctly
- ✓ Displays vehicle without optional fields
- ✓ Handles tap callback
- ✓ Displays correct color indicators
- ✓ Displays mileage with correct formatting
- ✓ Card has proper elevation and styling

#### MaintenanceCard (maintenance_card_test.dart)
- ✓ Displays maintenance information correctly
- ✓ Displays correct icon for each maintenance type (oil_change, tire_rotation, brake_service, inspection, repair)
- ✓ Displays correct label for each maintenance type
- ✓ Displays without optional fields
- ✓ Handles tap callback
- ✓ Truncates long descriptions with ellipsis
- ✓ Displays cost with correct formatting
- ✓ Does not display empty description

#### FuelCard (fuel_card_test.dart)
- ✓ Displays fuel information correctly
- ✓ Displays without optional fields
- ✓ Handles tap callback
- ✓ Formats gallons to 2 decimal places
- ✓ Formats cost to 2 decimal places
- ✓ Formats price per gallon to 2 decimal places
- ✓ Formats MPG to 1 decimal place
- ✓ Displays all icons correctly
- ✓ Card has proper elevation and styling

#### VehicleManagerScreen (vehicle_manager_screen_test.dart)
- ✓ Displays app bar with correct title
- ✓ Displays refresh button in app bar
- ✓ Displays header card with vehicle management info
- ✓ Displays "My Vehicles" section title
- ✓ Shows loading indicator initially
- ✓ Displays RefreshIndicator for pull-to-refresh
- ✓ Displays ListView for scrollable content
- ✓ Refresh button triggers data reload
- ✓ Displays summary card when summary data is loaded
- ✓ Has correct padding around content
- ✓ Uses correct userId passed to constructor
- ✓ Displays Scaffold with proper structure
- ✓ Summary card displays correct stat columns
- ✓ Displays error message when API call fails
- ✓ Screen remains functional after error
- ✓ Displays vehicle cards when vehicles are loaded
- ✓ Vehicle cards are tappable

#### VehicleDetailScreen (vehicle_detail_screen_test.dart)
- ✓ Displays app bar with vehicle name
- ✓ Displays TabBar with Maintenance and Fuel tabs
- ✓ Displays maintenance and fuel icons in tabs
- ✓ Displays TabBarView with correct children
- ✓ Shows loading indicator initially
- ✓ Displays back button in app bar
- ✓ TabController has correct length
- ✓ Can switch between tabs
- ✓ Displays Maintenance History title on maintenance tab
- ✓ Displays Fuel History title on fuel tab
- ✓ Uses correct parameters passed to constructor
- ✓ Has proper Scaffold structure
- ✓ Displays stats container when stats are loaded
- ✓ Stats are displayed in a Row layout
- ✓ Maintenance tab displays ListView
- ✓ Fuel tab displays ListView
- ✓ Tabs have correct padding
- ✓ Maintains tab selection during rebuild
- ✓ Properly disposes TabController

### Unit Tests

#### VehicleApiService (vehicle_api_service_test.dart)
- ✓ Successfully fetches vehicles for a user
- ✓ Successfully fetches a specific vehicle
- ✓ Successfully fetches maintenance records
- ✓ Handles empty maintenance records
- ✓ Successfully fetches fuel records without limit
- ✓ Successfully fetches fuel records with limit
- ✓ Constructs correct URL with limit parameter
- ✓ Successfully fetches maintenance schedule
- ✓ Successfully fetches vehicle statistics
- ✓ Successfully fetches user summary
- ✓ Throws exception on non-200 status code
- ✓ Throws exception on network error
- ✓ Includes status code in exception message
- ✓ Includes error details in exception message
- ✓ Uses custom base URL when provided
- ✓ Uses default localhost URL when not provided

### Integration Tests

#### Navigation (navigation_test.dart)
- ✓ Navigates from VehicleManagerScreen to VehicleDetailScreen when vehicle card is tapped
- ✓ Navigates back from VehicleDetailScreen to VehicleManagerScreen
- ✓ Maintains state when navigating back from detail screen
- ✓ Switches between Maintenance and Fuel tabs on detail screen
- ✓ Displays vehicle name in detail screen app bar
- ✓ Refresh button on main screen reloads data
- ✓ Pull to refresh on main screen reloads data
- ✓ Error state displays error message on main screen
- ✓ Loading state displays progress indicator
- ✓ Tab controller maintains state during navigation
- ✓ Swiping between tabs works correctly
- ✓ Handles navigation when no vehicles are available
- ✓ Correctly disposes of resources when navigating away

## Running Tests

### Run all tests
```bash
flutter test
```

### Run specific test file
```bash
flutter test test/widget_tests/vehicle_card_test.dart
```

### Run tests by directory
```bash
# Run all widget tests
flutter test test/widget_tests/

# Run all unit tests
flutter test test/unit_tests/

# Run all integration tests
flutter test test/integration_tests/
```

### Run tests with coverage
```bash
flutter test --coverage
```

### Run tests in verbose mode
```bash
flutter test --verbose
```

## Test Statistics

- **Total Test Files**: 7
- **Widget Test Files**: 5
- **Unit Test Files**: 1
- **Integration Test Files**: 1
- **Total Test Cases**: 90+

## Testing Best Practices

1. **Widget Tests**: Test UI components in isolation with different states and configurations
2. **Unit Tests**: Test business logic and service methods with mocked dependencies
3. **Integration Tests**: Test complete user flows and navigation scenarios
4. **Error Handling**: Verify proper error states and error messages
5. **State Management**: Ensure proper state updates and cleanup
6. **Accessibility**: Test widget accessibility features
7. **Performance**: Monitor test execution time and optimize slow tests

## CI/CD Integration

These tests can be integrated into your CI/CD pipeline:

```yaml
# Example GitHub Actions workflow
- name: Run Flutter Tests
  run: flutter test --coverage

- name: Upload Coverage
  uses: codecov/codecov-action@v3
  with:
    files: ./coverage/lcov.info
```

## Maintenance Notes

- Update tests when UI components change
- Add new tests for new features
- Keep test data realistic but minimal
- Mock external dependencies (API calls, shared preferences)
- Run tests before committing code
- Review test coverage regularly

## Known Limitations

- API service tests require the backend to be running on localhost:8030
- Some integration tests depend on mock data structure
- Tests assume Material Design 3 theme
- Navigation tests require widget tree to be properly set up

## Contributing

When adding new features:
1. Write tests first (TDD approach) or immediately after
2. Ensure all tests pass before submitting PR
3. Maintain test coverage above 80%
4. Document complex test scenarios
5. Use descriptive test names

## Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Widget Testing Guide](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing Guide](https://docs.flutter.dev/cookbook/testing/integration/introduction)
- [Mockito for Dart](https://pub.dev/packages/mockito)
