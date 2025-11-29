import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_ui/ui_components/fuel_card.dart';

void main() {
  group('FuelCard Widget Tests', () {
    testWidgets('displays fuel information correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FuelCard(
              date: '2024-01-20',
              mileage: 48000,
              gallons: 12.5,
              cost: 45.50,
              pricePerGallon: 3.64,
              mpg: 32.5,
            ),
          ),
        ),
      );

      // Verify date
      expect(find.text('2024-01-20'), findsOneWidget);

      // Verify mileage
      expect(find.text('48000 mi'), findsOneWidget);

      // Verify gallons
      expect(find.text('12.50 gal'), findsOneWidget);

      // Verify total cost
      expect(find.text('\$45.50'), findsOneWidget);

      // Verify price per gallon
      expect(find.text(' @ \$3.64/gal'), findsOneWidget);

      // Verify MPG
      expect(find.text('32.5 MPG'), findsOneWidget);

      // Verify gas station icon
      expect(find.byIcon(Icons.local_gas_station), findsOneWidget);
    });

    testWidgets('displays without optional fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FuelCard(
              date: '2024-01-20',
              mileage: 48000,
              gallons: 10.0,
              cost: 35.00,
            ),
          ),
        ),
      );

      // Basic fields should be present
      expect(find.text('2024-01-20'), findsOneWidget);
      expect(find.text('48000 mi'), findsOneWidget);
      expect(find.text('10.00 gal'), findsOneWidget);
      expect(find.text('\$35.00'), findsOneWidget);

      // Optional fields should not be present
      expect(find.textContaining('MPG'), findsNothing);
      expect(find.textContaining('/gal'), findsNothing);
    });

    testWidgets('handles tap callback', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FuelCard(
              date: '2024-02-01',
              mileage: 50000,
              gallons: 15.0,
              cost: 52.50,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      // Tap the card
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('formats gallons to 2 decimal places', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FuelCard(
              date: '2024-01-20',
              mileage: 48000,
              gallons: 12.567,
              cost: 45.50,
            ),
          ),
        ),
      );

      // Verify gallons is formatted to 2 decimal places
      expect(find.text('12.57 gal'), findsOneWidget);
    });

    testWidgets('formats cost to 2 decimal places', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FuelCard(
              date: '2024-01-20',
              mileage: 48000,
              gallons: 12.5,
              cost: 45.567,
            ),
          ),
        ),
      );

      // Verify cost is formatted to 2 decimal places
      expect(find.text('\$45.57'), findsOneWidget);
    });

    testWidgets('formats price per gallon to 2 decimal places', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FuelCard(
              date: '2024-01-20',
              mileage: 48000,
              gallons: 12.5,
              cost: 45.50,
              pricePerGallon: 3.645,
            ),
          ),
        ),
      );

      // Verify price per gallon is formatted to 2 decimal places
      expect(find.text(' @ \$3.65/gal'), findsOneWidget);
    });

    testWidgets('formats MPG to 1 decimal place', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FuelCard(
              date: '2024-01-20',
              mileage: 48000,
              gallons: 12.5,
              cost: 45.50,
              mpg: 32.567,
            ),
          ),
        ),
      );

      // Verify MPG is formatted to 1 decimal place
      expect(find.text('32.6 MPG'), findsOneWidget);
    });

    testWidgets('displays all icons correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FuelCard(
              date: '2024-01-20',
              mileage: 48000,
              gallons: 12.5,
              cost: 45.50,
              mpg: 32.5,
            ),
          ),
        ),
      );

      // Verify speed icon for mileage
      expect(find.byIcon(Icons.speed), findsOneWidget);

      // Verify gas station icon
      expect(find.byIcon(Icons.local_gas_station), findsOneWidget);
    });

    testWidgets('card has proper elevation and styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FuelCard(
              date: '2024-01-20',
              mileage: 48000,
              gallons: 12.5,
              cost: 45.50,
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 1);
    });
  });
}
