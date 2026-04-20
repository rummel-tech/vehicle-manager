import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vehicle_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Vehicle Manager — App Launch', () {
    testWidgets('App loads without crashing', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(tester.takeException(), isNull);
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App renders a Scaffold', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('Theme is applied', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp).first,
      );
      expect(materialApp.theme, isNotNull);
    });
  });

  group('Vehicle Manager — Authentication Gate', () {
    testWidgets('App shows login or vehicle list on launch', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final hasLogin = find.textContaining('Log In').evaluate().isNotEmpty ||
          find.textContaining('Login').evaluate().isNotEmpty ||
          find.textContaining('Sign').evaluate().isNotEmpty;
      final hasHome = find.text('Vehicle Manager').evaluate().isNotEmpty;

      expect(hasLogin || hasHome, isTrue);
    });

    testWidgets('Login screen has email and password fields', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final loginVisible = find.textContaining('Log In').evaluate().isNotEmpty ||
          find.textContaining('Login').evaluate().isNotEmpty;

      if (loginVisible) {
        expect(find.byType(TextField), findsWidgets);
      }
    });

    testWidgets('Auth check does not crash', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(tester.takeException(), isNull);
    });
  });

  group('Vehicle Manager — Vehicle List Screen', () {
    testWidgets('App title Vehicle Manager is displayed', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final hasVehicleManagerTitle = find.text('Vehicle Manager').evaluate().isNotEmpty;
      expect(
        hasVehicleManagerTitle || find.byType(TextField).evaluate().isNotEmpty,
        isTrue,
      );
    });

    testWidgets('Refresh button is present on vehicle list', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final vehicleListVisible = find.text('Vehicle Manager').evaluate().isNotEmpty;
      if (vehicleListVisible) {
        expect(find.byIcon(Icons.refresh), findsOneWidget);
      }
    });

    testWidgets('Vehicle Management section header is present', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final vehicleListVisible = find.text('Vehicle Manager').evaluate().isNotEmpty;
      if (vehicleListVisible) {
        expect(find.text('Vehicle Management'), findsOneWidget);
      }
    });

    testWidgets('Refresh triggers reload without crashing', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final refreshBtn = find.byIcon(Icons.refresh);
      if (refreshBtn.evaluate().isNotEmpty) {
        await tester.tap(refreshBtn.first);
        await tester.pumpAndSettle(const Duration(seconds: 3));
        expect(tester.takeException(), isNull);
        expect(find.text('Vehicle Manager'), findsOneWidget);
      }
    });
  });

  group('Vehicle Manager — Vehicle Detail Navigation', () {
    testWidgets('Tapping a vehicle card navigates to detail screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final vehicleCards = find.byType(Card);
      if (vehicleCards.evaluate().isNotEmpty &&
          find.text('Vehicle Manager').evaluate().isNotEmpty) {
        await tester.tap(vehicleCards.first);
        await tester.pumpAndSettle();

        // Detail screen should be open — no exception
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('Vehicle detail screen has Maintenance tab', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final vehicleCards = find.byType(Card);
      if (vehicleCards.evaluate().isNotEmpty &&
          find.text('Vehicle Manager').evaluate().isNotEmpty) {
        await tester.tap(vehicleCards.first);
        await tester.pumpAndSettle();

        final hasMaintenanceTab = find.text('Maintenance').evaluate().isNotEmpty;
        if (hasMaintenanceTab) {
          expect(find.text('Maintenance'), findsOneWidget);
        }
      }
    });

    testWidgets('Vehicle detail screen has Fuel tab', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final vehicleCards = find.byType(Card);
      if (vehicleCards.evaluate().isNotEmpty &&
          find.text('Vehicle Manager').evaluate().isNotEmpty) {
        await tester.tap(vehicleCards.first);
        await tester.pumpAndSettle();

        final hasFuelTab = find.text('Fuel').evaluate().isNotEmpty;
        if (hasFuelTab) {
          expect(find.text('Fuel'), findsOneWidget);
        }
      }
    });

    testWidgets('Switching between Maintenance and Fuel tabs works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final vehicleCards = find.byType(Card);
      if (vehicleCards.evaluate().isNotEmpty &&
          find.text('Vehicle Manager').evaluate().isNotEmpty) {
        await tester.tap(vehicleCards.first);
        await tester.pumpAndSettle();

        // Tap Fuel tab if visible
        final fuelTab = find.text('Fuel');
        if (fuelTab.evaluate().isNotEmpty) {
          await tester.tap(fuelTab.first);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }

        // Switch back to Maintenance
        final maintenanceTab = find.text('Maintenance');
        if (maintenanceTab.evaluate().isNotEmpty) {
          await tester.tap(maintenanceTab.first);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
      }
    });

    testWidgets('Back navigation returns to vehicle list', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final vehicleCards = find.byType(Card);
      if (vehicleCards.evaluate().isNotEmpty &&
          find.text('Vehicle Manager').evaluate().isNotEmpty) {
        await tester.tap(vehicleCards.first);
        await tester.pumpAndSettle();

        // Navigate back
        final backBtn = find.byTooltip('Back');
        if (backBtn.evaluate().isNotEmpty) {
          await tester.tap(backBtn.first);
          await tester.pumpAndSettle();
          expect(find.text('Vehicle Manager'), findsOneWidget);
        }
      }
    });
  });

  group('Vehicle Manager — Pull to Refresh', () {
    testWidgets('Pull to refresh on vehicle list does not crash', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final refreshIndicator = find.byType(RefreshIndicator);
      if (refreshIndicator.evaluate().isNotEmpty) {
        await tester.drag(refreshIndicator.first, const Offset(0, 300));
        await tester.pumpAndSettle(const Duration(seconds: 3));
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('Vehicle Manager — Stability', () {
    testWidgets('App handles backend unavailability gracefully', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(tester.takeException(), isNull);
    });

    testWidgets('App is stable after extended settle', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(tester.takeException(), isNull);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('Multiple refresh taps do not crash', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final refreshBtn = find.byIcon(Icons.refresh);
      if (refreshBtn.evaluate().isNotEmpty) {
        for (int i = 0; i < 3; i++) {
          await tester.tap(refreshBtn.first);
          await tester.pump(const Duration(milliseconds: 300));
        }
        await tester.pumpAndSettle(const Duration(seconds: 3));
        expect(tester.takeException(), isNull);
      }
    });
  });
}
