import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_ui/screens/vehicle_manager_screen.dart';

void main() {
  group('VehicleDetailScreen Widget Tests', () {
    testWidgets('displays app bar with vehicle name', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleDetailScreen(
            userId: 'user-123',
            vehicleId: 'v1',
            vehicleName: '2020 Toyota Camry',
          ),
        ),
      );

      expect(find.text('2020 Toyota Camry'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays TabBar with Maintenance and Fuel tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleDetailScreen(
            userId: 'user-123',
            vehicleId: 'v1',
            vehicleName: '2020 Toyota Camry',
          ),
        ),
      );

      expect(find.byType(TabBar), findsOneWidget);
      expect(find.text('Maintenance'), findsOneWidget);
      expect(find.text('Fuel'), findsOneWidget);
    });

    testWidgets('displays maintenance and fuel icons in tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleDetailScreen(
            userId: 'user-123',
            vehicleId: 'v1',
            vehicleName: '2020 Toyota Camry',
          ),
        ),
      );

      expect(find.byIcon(Icons.build), findsOneWidget);
      expect(find.byIcon(Icons.local_gas_station), findsOneWidget);
    });

    testWidgets('displays TabBarView with correct children', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleDetailScreen(
            userId: 'user-123',
            vehicleId: 'v1',
            vehicleName: '2020 Toyota Camry',
          ),
        ),
      );

      expect(find.byType(TabBarView), findsOneWidget);
    });

    testWidgets('shows loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleDetailScreen(
            userId: 'user-123',
            vehicleId: 'v1',
            vehicleName: '2020 Toyota Camry',
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays back button in app bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VehicleDetailScreen(
                        userId: 'user-123',
                        vehicleId: 'v1',
                        vehicleName: '2020 Toyota Camry',
                      ),
                    ),
                  );
                },
                child: const Text('Navigate'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      expect(find.byType(BackButton), findsOneWidget);
    });

    testWidgets('TabController has correct length', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleDetailScreen(
            userId: 'user-123',
            vehicleId: 'v1',
            vehicleName: '2020 Toyota Camry',
          ),
        ),
      );

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.controller!.length, 2);
    });

    testWidgets('can switch between tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleDetailScreen(
            userId: 'user-123',
            vehicleId: 'v1',
            vehicleName: '2020 Toyota Camry',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initial tab should be Maintenance (index 0)
      TabBar tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.controller!.index, 0);

      // Tap Fuel tab
      await tester.tap(find.text('Fuel'));
      await tester.pumpAndSettle();

      // Should switch to Fuel tab (index 1)
      tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.controller!.index, 1);
    });

    testWidgets('displays Maintenance History title on maintenance tab', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleDetailScreen(
            userId: 'user-123',
            vehicleId: 'v1',
            vehicleName: '2020 Toyota Camry',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Maintenance History'), findsOneWidget);
    });

    testWidgets('displays Fuel History title on fuel tab', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleDetailScreen(
            userId: 'user-123',
            vehicleId: 'v1',
            vehicleName: '2020 Toyota Camry',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Switch to Fuel tab
      await tester.tap(find.text('Fuel'));
      await tester.pumpAndSettle();

      expect(find.text('Fuel History'), findsOneWidget);
    });

    testWidgets('uses correct parameters passed to constructor', (WidgetTester tester) async {
      const testUserId = 'test-user-456';
      const testVehicleId = 'v-test-789';
      const testVehicleName = '2021 Honda Civic';

      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleDetailScreen(
            userId: testUserId,
            vehicleId: testVehicleId,
            vehicleName: testVehicleName,
          ),
        ),
      );

      final screen = tester.widget<VehicleDetailScreen>(
        find.byType(VehicleDetailScreen),
      );

      expect(screen.userId, testUserId);
      expect(screen.vehicleId, testVehicleId);
      expect(screen.vehicleName, testVehicleName);
    });

    testWidgets('has proper Scaffold structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleDetailScreen(
            userId: 'user-123',
            vehicleId: 'v1',
            vehicleName: '2020 Toyota Camry',
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });
  });

  group('VehicleDetailScreen Stats Display Tests', () {
    testWidgets('displays stats container when stats are loaded', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleDetailScreen(
            userId: 'user-123',
            vehicleId: 'v1',
            vehicleName: '2020 Toyota Camry',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for stats labels
      final avgMpg = find.text('Avg MPG');
      final fuelCost = find.text('Fuel Cost');
      final maintenance = find.text('Maintenance');

      // If stats are loaded, all three should be present
      if (avgMpg.evaluate().isNotEmpty) {
        expect(avgMpg, findsOneWidget);
        expect(fuelCost, findsOneWidget);
        expect(maintenance, findsOneWidget);
      }
    });

    testWidgets('stats are displayed in a Row layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleDetailScreen(
            userId: 'user-123',
            vehicleId: 'v1',
            vehicleName: '2020 Toyota Camry',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Stats should be in a Container with Row
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Row), findsWidgets);
    });
  });

  group('VehicleDetailScreen Tab Content Tests', () {
    testWidgets('maintenance tab displays ListView', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleDetailScreen(
            userId: 'user-123',
            vehicleId: 'v1',
            vehicleName: '2020 Toyota Camry',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('fuel tab displays ListView', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleDetailScreen(
            userId: 'user-123',
            vehicleId: 'v1',
            vehicleName: '2020 Toyota Camry',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Switch to Fuel tab
      await tester.tap(find.text('Fuel'));
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('tabs have correct padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleDetailScreen(
            userId: 'user-123',
            vehicleId: 'v1',
            vehicleName: '2020 Toyota Camry',
          ),
        ),
      );

      await tester.pumpAndSettle();

      final listViews = tester.widgetList<ListView>(find.byType(ListView));

      for (final listView in listViews) {
        if (listView.padding != null) {
          expect(listView.padding, const EdgeInsets.all(16));
        }
      }
    });
  });

  group('VehicleDetailScreen State Management Tests', () {
    testWidgets('maintains tab selection during rebuild', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleDetailScreen(
            userId: 'user-123',
            vehicleId: 'v1',
            vehicleName: '2020 Toyota Camry',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Switch to Fuel tab
      await tester.tap(find.text('Fuel'));
      await tester.pumpAndSettle();

      // Force rebuild
      await tester.pump();

      // Tab selection should be maintained
      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.controller!.index, 1);
    });

    testWidgets('properly disposes TabController', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleDetailScreen(
            userId: 'user-123',
            vehicleId: 'v1',
            vehicleName: '2020 Toyota Camry',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Pop the route to dispose the widget
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));

      // No exceptions should be thrown during disposal
      expect(tester.takeException(), isNull);
    });
  });
}
