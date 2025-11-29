import 'package:shared_services/shared_services.dart';

class VehicleApiService {
  final BaseApiClient _client;

  VehicleApiService({BaseApiClient? client})
      : _client = client ?? BaseApiClient(config: AppConfigs.vehicleManager());

  Future<Map<String, dynamic>> getVehicles(String userId) async {
    return await _client.get<Map<String, dynamic>>(
      '/vehicles/$userId',
      fromJson: (json) => json,
    );
  }

  Future<Map<String, dynamic>> getVehicle(String userId, String vehicleId) async {
    return await _client.get<Map<String, dynamic>>(
      '/vehicles/$userId/$vehicleId',
      fromJson: (json) => json,
    );
  }

  Future<Map<String, dynamic>> getMaintenanceRecords(String vehicleId) async {
    return await _client.get<Map<String, dynamic>>(
      '/maintenance/$vehicleId',
      fromJson: (json) => json,
    );
  }

  Future<Map<String, dynamic>> getFuelRecords(String vehicleId, {int? limit}) async {
    return await _client.get<Map<String, dynamic>>(
      '/fuel/$vehicleId',
      queryParameters: limit != null ? {'limit': limit.toString()} : null,
      fromJson: (json) => json,
    );
  }

  Future<Map<String, dynamic>> getMaintenanceSchedule(String vehicleId) async {
    return await _client.get<Map<String, dynamic>>(
      '/schedule/$vehicleId',
      fromJson: (json) => json,
    );
  }

  Future<Map<String, dynamic>> getVehicleStats(String vehicleId) async {
    return await _client.get<Map<String, dynamic>>(
      '/stats/$vehicleId',
      fromJson: (json) => json,
    );
  }

  Future<Map<String, dynamic>> getUserSummary(String userId) async {
    return await _client.get<Map<String, dynamic>>(
      '/summary/$userId',
      fromJson: (json) => json,
    );
  }

  void dispose() {
    _client.dispose();
  }
}
