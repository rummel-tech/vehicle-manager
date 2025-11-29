import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_ui/services/vehicle_api_service.dart';

void main() {
  group('VehicleApiService Configuration Tests', () {
    late VehicleApiService apiService;

    setUp(() {
      apiService = VehicleApiService(baseUrl: 'http://localhost:8030');
    });

    group('Base URL Configuration', () {
      test('uses custom base URL when provided', () {
        final customService = VehicleApiService(
          baseUrl: 'https://api.example.com',
        );

        expect(customService.baseUrl, 'https://api.example.com');
      });

      test('uses default localhost URL when not provided', () {
        final defaultService = VehicleApiService();

        expect(defaultService.baseUrl, 'http://localhost:8030');
      });

      test('baseUrl is accessible', () {
        expect(apiService.baseUrl, 'http://localhost:8030');
      });
    });

    group('Service Instantiation', () {
      test('can create service with default parameters', () {
        final service = VehicleApiService();
        expect(service, isA<VehicleApiService>());
        expect(service.baseUrl, isNotNull);
      });

      test('can create service with custom base URL', () {
        final service = VehicleApiService(baseUrl: 'https://custom.api.com');
        expect(service, isA<VehicleApiService>());
        expect(service.baseUrl, 'https://custom.api.com');
      });

      test('can create multiple service instances', () {
        final service1 = VehicleApiService(baseUrl: 'https://api1.com');
        final service2 = VehicleApiService(baseUrl: 'https://api2.com');

        expect(service1.baseUrl, 'https://api1.com');
        expect(service2.baseUrl, 'https://api2.com');
      });
    });

    group('Service Methods Exist', () {
      test('has getVehicles method', () {
        expect(apiService.getVehicles, isA<Function>());
      });

      test('has getVehicle method', () {
        expect(apiService.getVehicle, isA<Function>());
      });

      test('has getMaintenanceRecords method', () {
        expect(apiService.getMaintenanceRecords, isA<Function>());
      });

      test('has getFuelRecords method', () {
        expect(apiService.getFuelRecords, isA<Function>());
      });

      test('has getMaintenanceSchedule method', () {
        expect(apiService.getMaintenanceSchedule, isA<Function>());
      });

      test('has getVehicleStats method', () {
        expect(apiService.getVehicleStats, isA<Function>());
      });

      test('has getUserSummary method', () {
        expect(apiService.getUserSummary, isA<Function>());
      });
    });
  });

  group('VehicleApiService Integration Tests (requires running backend)', () {
    late VehicleApiService apiService;

    setUp(() {
      apiService = VehicleApiService(baseUrl: 'http://localhost:8030');
    });

    test('getVehicles returns Future<Map<String, dynamic>>', () {
      final result = apiService.getVehicles('user-123');
      expect(result, isA<Future<Map<String, dynamic>>>());
    });

    test('getVehicle returns Future<Map<String, dynamic>>', () {
      final result = apiService.getVehicle('user-123', 'v1');
      expect(result, isA<Future<Map<String, dynamic>>>());
    });

    test('getMaintenanceRecords returns Future<Map<String, dynamic>>', () {
      final result = apiService.getMaintenanceRecords('v1');
      expect(result, isA<Future<Map<String, dynamic>>>());
    });

    test('getFuelRecords returns Future<Map<String, dynamic>>', () {
      final result = apiService.getFuelRecords('v1');
      expect(result, isA<Future<Map<String, dynamic>>>());
    });

    test('getFuelRecords with limit returns Future<Map<String, dynamic>>', () {
      final result = apiService.getFuelRecords('v1', limit: 5);
      expect(result, isA<Future<Map<String, dynamic>>>());
    });

    test('getMaintenanceSchedule returns Future<Map<String, dynamic>>', () {
      final result = apiService.getMaintenanceSchedule('v1');
      expect(result, isA<Future<Map<String, dynamic>>>());
    });

    test('getVehicleStats returns Future<Map<String, dynamic>>', () {
      final result = apiService.getVehicleStats('v1');
      expect(result, isA<Future<Map<String, dynamic>>>());
    });

    test('getUserSummary returns Future<Map<String, dynamic>>', () {
      final result = apiService.getUserSummary('user-123');
      expect(result, isA<Future<Map<String, dynamic>>>());
    });
  });
}
