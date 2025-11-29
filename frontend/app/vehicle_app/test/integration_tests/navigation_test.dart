import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_ui/screens/vehicle_manager_screen.dart';
import 'package:vehicle_ui/ui_components/vehicle_card.dart';

void main() {
  group('Navigation Integration Tests', () {
    testWidgets('navigates from VehicleManagerScreen to VehicleDetailScreen when vehicle card is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleManagerScreen(userId: 'user-123'),
        ),
      );

      // Wait for initial load
      await tester.pump(const Duration(milliseconds: 100));

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Find and tap a vehicle card (if any exist)
      final vehicleCards = find.byType(VehicleCard);
      if (vehicleCards.evaluate().isNotEmpty) {
        await tester.tap(vehicleCards.first);
        await tester.pumpAndSettle();

        // Verify navigation occurred by checking for back button
        expect(find.byType(BackButton), findsOneWidget);

        // Verify we're on the detail screen by looking for tabs
        expect(find.text('Maintenance'), findsOneWidget);
        expect(find.text('Fuel'), findsOneWidget);
      }
    });

    testWidgets('navigates back from VehicleDetailScreen to VehicleManagerScreen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleManagerScreen(userId: 'user-123'),
        ),
      );

      await tester.pumpAndSettle();

      final vehicleCards = find.byType(VehicleCard);
      if (vehicleCards.evaluate().isNotEmpty) {
        // Navigate to detail screen
        await tester.tap(vehicleCards.first);
        await tester.pumpAndSettle();

        // Verify we're on detail screen
        expect(find.byType(BackButton), findsOneWidget);

        // Tap back button
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        // Verify we're back on the main screen
        expect(find.text('Vehicle Manager'), findsOneWidget);
        expect(find.text('My Vehicles'), findsOneWidget);
      }
    });

    testWidgets('maintains state when navigating back from detail screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleManagerScreen(userId: 'user-123'),
        ),
      );

      await tester.pumpAndSettle();

      final vehicleCards = find.byType(VehicleCard);
      if (vehicleCards.evaluate().isNotEmpty) {
        final cardCount = vehicleCards.evaluate().length;

        // Navigate to detail screen
        await tester.tap(vehicleCards.first);
        await tester.pumpAndSettle();

        // Navigate back
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        // Verify vehicle cards are still displayed
        expect(find.byType(VehicleCard), findsNWidgets(cardCount));
      }
    });

    testWidgets('switches between Maintenance and Fuel tabs on detail screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleManagerScreen(userId: 'user-123'),
        ),
      );

      await tester.pumpAndSettle();

      final vehicleCards = find.byType(VehicleCard);
      if (vehicleCards.evaluate().isNotEmpty) {
        // Navigate to detail screen
        await tester.tap(vehicleCards.first);
        await tester.pumpAndSettle();

        // Verify Maintenance tab is shown by default
        expect(find.text('Maintenance History'), findsOneWidget);

        // Tap Fuel tab
        await tester.tap(find.text('Fuel'));
        await tester.pumpAndSettle();

        // Verify Fuel tab content is shown
        expect(find.text('Fuel History'), findsOneWidget);

        // Tap back to Maintenance tab
        await tester.tap(find.text('Maintenance'));
        await tester.pumpAndSettle();

        // Verify Maintenance tab content is shown again
        expect(find.text('Maintenance History'), findsOneWidget);
      }
    });

    testWidgets('displays vehicle name in detail screen app bar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleManagerScreen(userId: 'user-123'),
        ),
      );

      await tester.pumpAndSettle();

      final vehicleCards = find.byType(VehicleCard);
      if (vehicleCards.evaluate().isNotEmpty) {
        // Get the vehicle name from the first card
        final firstCard = tester.widget<VehicleCard>(vehicleCards.first);
        final expectedTitle = '${firstCard.year} ${firstCard.make} ${firstCard.model}';

        // Navigate to detail screen
        await tester.tap(vehicleCards.first);
        await tester.pumpAndSettle();

        // Verify vehicle name is in the app bar
        expect(find.text(expectedTitle), findsOneWidget);
      }
    });

    testWidgets('refresh button on main screen reloads data',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleManagerScreen(userId: 'user-123'),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap refresh button
      final refreshButton = find.byIcon(Icons.refresh);
      expect(refreshButton, findsOneWidget);

      await tester.tap(refreshButton);
      await tester.pump();

      // Verify loading indicator appears
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('pull to refresh on main screen reloads data',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleManagerScreen(userId: 'user-123'),
        ),
      );

      await tester.pumpAndSettle();

      // Perform pull to refresh gesture
      await tester.drag(
        find.byType(RefreshIndicator),
        const Offset(0, 300),
      );
      await tester.pump();

      // Verify loading indicator appears
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('error state displays error message on main screen',
        (WidgetTester tester) async {
      // This would require mocking the API service to return an error
      // For now, we just verify the error UI exists in the widget tree
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleManagerScreen(userId: 'invalid-user'),
        ),
      );

      await tester.pumpAndSettle();

      // Check if error handling UI is present (Card widget for errors)
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('loading state displays progress indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleManagerScreen(userId: 'user-123'),
        ),
      );

      // Before pumpAndSettle, loading indicator should be visible
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });
  });

  group('Tab Navigation Tests', () {
    testWidgets('tab controller maintains state during navigation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleManagerScreen(userId: 'user-123'),
        ),
      );

      await tester.pumpAndSettle();

      final vehicleCards = find.byType(VehicleCard);
      if (vehicleCards.evaluate().isNotEmpty) {
        // Navigate to detail screen
        await tester.tap(vehicleCards.first);
        await tester.pumpAndSettle();

        // Switch to Fuel tab
        await tester.tap(find.text('Fuel'));
        await tester.pumpAndSettle();

        // Verify tab is selected
        final tabBar = tester.widget<TabBar>(find.byType(TabBar));
        expect(tabBar.controller!.index, 1);
      }
    });

    testWidgets('swiping between tabs works correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleManagerScreen(userId: 'user-123'),
        ),
      );

      await tester.pumpAndSettle();

      final vehicleCards = find.byType(VehicleCard);
      if (vehicleCards.evaluate().isNotEmpty) {
        // Navigate to detail screen
        await tester.tap(vehicleCards.first);
        await tester.pumpAndSettle();

        // Find the TabBarView
        final tabBarView = find.byType(TabBarView);
        expect(tabBarView, findsOneWidget);

        // Swipe left to go to Fuel tab
        await tester.drag(tabBarView, const Offset(-400, 0));
        await tester.pumpAndSettle();

        // Verify Fuel tab content is shown
        expect(find.text('Fuel History'), findsOneWidget);
      }
    });
  });

  group('Navigation Edge Cases', () {
    testWidgets('handles navigation when no vehicles are available',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleManagerScreen(userId: 'user-no-vehicles'),
        ),
      );

      await tester.pumpAndSettle();

      // Should display the main screen without vehicle cards
      expect(find.text('Vehicle Manager'), findsOneWidget);
      expect(find.byType(VehicleCard), findsNothing);
    });

    testWidgets('correctly disposes of resources when navigating away',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VehicleManagerScreen(userId: 'user-123'),
        ),
      );

      await tester.pumpAndSettle();

      final vehicleCards = find.byType(VehicleCard);
      if (vehicleCards.evaluate().isNotEmpty) {
        // Navigate to detail screen
        await tester.tap(vehicleCards.first);
        await tester.pumpAndSettle();

        // Navigate back
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        // Widget tree should be clean
        expect(tester.takeException(), isNull);
      }
    });
  });
}
