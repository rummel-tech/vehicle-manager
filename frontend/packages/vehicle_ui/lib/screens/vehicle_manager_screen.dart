import 'package:flutter/material.dart';
import '../services/vehicle_api_service.dart';
import '../ui_components/vehicle_card.dart';
import '../ui_components/maintenance_card.dart';
import '../ui_components/fuel_card.dart';
import '../config/app_config.dart';

class VehicleManagerScreen extends StatefulWidget {
  final String userId;
  final VoidCallback? onLogout;

  const VehicleManagerScreen({super.key, required this.userId, this.onLogout});

  @override
  State<VehicleManagerScreen> createState() => _VehicleManagerScreenState();
}

class _VehicleManagerScreenState extends State<VehicleManagerScreen> {
  late final VehicleApiService _apiService;

  @override
  void initState() {
    super.initState();
    // Initialize API service with configured base URL
    final config = AppConfig.instance();
    _apiService = VehicleApiService(baseUrl: config.apiBaseUrl);
    if (config.debug) {
      print('VehicleManagerScreen using API: ${config.apiBaseUrl}');
    }
    _loadData();
  }
  bool _loadingVehicles = true;
  bool _loadingSummary = true;
  String? _error;
  Map<String, dynamic>? _vehicles;
  Map<String, dynamic>? _summary;

  Future<void> _loadData() async {
    await Future.wait([
      _loadVehicles(),
      _loadSummary(),
    ]);
  }

  Future<void> _loadVehicles() async {
    setState(() {
      _loadingVehicles = true;
      _error = null;
    });
    try {
      final data = await _apiService.getVehicles(widget.userId);
      setState(() {
        _vehicles = data;
        _loadingVehicles = false;
      });
    } catch (e) {
      setState(() {
        _error = '$e';
        _loadingVehicles = false;
      });
    }
  }

  Future<void> _loadSummary() async {
    setState(() {
      _loadingSummary = true;
    });
    try {
      final data = await _apiService.getUserSummary(widget.userId);
      setState(() {
        _summary = data;
        _loadingSummary = false;
      });
    } catch (e) {
      setState(() {
        _loadingSummary = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loadData,
          ),
          if (widget.onLogout != null)
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: widget.onLogout,
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 1,
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.directions_car)),
                title: const Text('Vehicle Management'),
                subtitle: const Text('Track maintenance, fuel, and mileage'),
              ),
            ),
            const SizedBox(height: 16),

            // Summary Stats
            if (!_loadingSummary && _summary != null)
              _buildSummaryCard(),

            const SizedBox(height: 16),

            // Vehicles List
            Text(
              'My Vehicles',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (_loadingVehicles)
              const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
            else if (_error != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error: $_error', style: const TextStyle(color: Colors.red)),
                ),
              )
            else if (_vehicles != null) ...[
              ...(_vehicles!['vehicles'] as List<dynamic>).map((vehicle) {
                return VehicleCard(
                  make: vehicle['make'] ?? '',
                  model: vehicle['model'] ?? '',
                  year: vehicle['year'] ?? 0,
                  currentMileage: vehicle['current_mileage'] ?? 0,
                  color: vehicle['color'],
                  licensePlate: vehicle['license_plate'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VehicleDetailScreen(
                          userId: widget.userId,
                          vehicleId: vehicle['id'],
                          vehicleName: '${vehicle['year']} ${vehicle['make']} ${vehicle['model']}',
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 2,
      color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _statColumn(
                    'Vehicles',
                    '${_summary!['total_vehicles']}',
                    'registered',
                  ),
                ),
                Expanded(
                  child: _statColumn(
                    'Fuel Cost',
                    '\$${_summary!['total_fuel_cost']}',
                    'total',
                  ),
                ),
                Expanded(
                  child: _statColumn(
                    'Maintenance',
                    '\$${_summary!['total_maintenance_cost']}',
                    'total',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statColumn(String label, String value, String subtitle) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }
}

class VehicleDetailScreen extends StatefulWidget {
  final String userId;
  final String vehicleId;
  final String vehicleName;

  const VehicleDetailScreen({
    super.key,
    required this.userId,
    required this.vehicleId,
    required this.vehicleName,
  });

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> with SingleTickerProviderStateMixin {
  late final VehicleApiService _apiService;
  late TabController _tabController;
  bool _loadingMaintenance = true;
  bool _loadingFuel = true;
  bool _loadingStats = true;
  Map<String, dynamic>? _maintenance;
  Map<String, dynamic>? _fuel;
  Map<String, dynamic>? _stats;

  @override
  void initState() {
    super.initState();
    // Initialize API service with configured base URL
    final config = AppConfig.instance();
    _apiService = VehicleApiService(baseUrl: config.apiBaseUrl);
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadMaintenance(),
      _loadFuel(),
      _loadStats(),
    ]);
  }

  Future<void> _loadMaintenance() async {
    setState(() => _loadingMaintenance = true);
    try {
      final data = await _apiService.getMaintenanceRecords(widget.vehicleId);
      setState(() {
        _maintenance = data;
        _loadingMaintenance = false;
      });
    } catch (e) {
      setState(() => _loadingMaintenance = false);
    }
  }

  Future<void> _loadFuel() async {
    setState(() => _loadingFuel = true);
    try {
      final data = await _apiService.getFuelRecords(widget.vehicleId, limit: 10);
      setState(() {
        _fuel = data;
        _loadingFuel = false;
      });
    } catch (e) {
      setState(() => _loadingFuel = false);
    }
  }

  Future<void> _loadStats() async {
    setState(() => _loadingStats = true);
    try {
      final data = await _apiService.getVehicleStats(widget.vehicleId);
      setState(() {
        _stats = data;
        _loadingStats = false;
      });
    } catch (e) {
      setState(() => _loadingStats = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicleName),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Maintenance', icon: Icon(Icons.build, size: 20)),
            Tab(text: 'Fuel', icon: Icon(Icons.local_gas_station, size: 20)),
          ],
        ),
      ),
      body: Column(
        children: [
          if (!_loadingStats && _stats != null)
            Container(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _smallStatColumn(
                      'Avg MPG',
                      '${_stats!['fuel']['average_mpg']}',
                    ),
                  ),
                  Expanded(
                    child: _smallStatColumn(
                      'Fuel Cost',
                      '\$${_stats!['fuel']['total_cost']}',
                    ),
                  ),
                  Expanded(
                    child: _smallStatColumn(
                      'Maintenance',
                      '\$${_stats!['maintenance']['total_cost']}',
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMaintenanceTab(),
                _buildFuelTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceTab() {
    if (_loadingMaintenance) {
      return const Center(child: CircularProgressIndicator());
    }

    final records = _maintenance?['records'] as List<dynamic>? ?? [];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Maintenance History',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...records.map((record) {
          return MaintenanceCard(
            type: record['type'] ?? '',
            date: record['date'] ?? '',
            mileage: record['mileage'] ?? 0,
            cost: record['cost']?.toDouble(),
            description: record['description'],
            nextDueMileage: record['next_due_mileage'],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildFuelTab() {
    if (_loadingFuel) {
      return const Center(child: CircularProgressIndicator());
    }

    final records = _fuel?['records'] as List<dynamic>? ?? [];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Fuel History',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...records.map((record) {
          return FuelCard(
            date: record['date'] ?? '',
            mileage: record['mileage'] ?? 0,
            gallons: record['gallons']?.toDouble() ?? 0.0,
            cost: record['cost']?.toDouble() ?? 0.0,
            pricePerGallon: record['price_per_gallon']?.toDouble(),
            mpg: record['mpg']?.toDouble(),
          );
        }).toList(),
      ],
    );
  }

  Widget _smallStatColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
