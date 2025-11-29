import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_ui/ui_components/vehicle_card.dart';

void main() {
  group('VehicleCard Widget Tests', () {
    testWidgets('displays vehicle information correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VehicleCard(
              make: 'Toyota',
              model: 'Camry',
              year: 2020,
              currentMileage: 45000,
              licensePlate: 'ABC-1234',
              color: 'blue',
            ),
          ),
        ),
      );

      // Verify vehicle name
      expect(find.text('2020 Toyota Camry'), findsOneWidget);

      // Verify license plate
      expect(find.text('ABC-1234'), findsOneWidget);

      // Verify mileage
      expect(find.text('45000 mi'), findsOneWidget);

      // Verify color
      expect(find.text('blue'), findsOneWidget);

      // Verify car icon
      expect(find.byIcon(Icons.directions_car), findsOneWidget);

      // Verify chevron icon
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('displays vehicle without optional fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VehicleCard(
              make: 'Honda',
              model: 'Civic',
              year: 2019,
              currentMileage: 30000,
            ),
          ),
        ),
      );

      // Verify vehicle name
      expect(find.text('2019 Honda Civic'), findsOneWidget);

      // Verify mileage
      expect(find.text('30000 mi'), findsOneWidget);

      // License plate should not be displayed
      expect(find.byType(Text), findsNWidgets(2)); // Only name and mileage
    });

    testWidgets('handles tap callback', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VehicleCard(
              make: 'Ford',
              model: 'F-150',
              year: 2021,
              currentMileage: 15000,
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

    testWidgets('displays correct color indicators', (WidgetTester tester) async {
      final colors = ['red', 'blue', 'green', 'black', 'white', 'silver', 'gray'];

      for (final colorName in colors) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: VehicleCard(
                make: 'Test',
                model: 'Car',
                year: 2020,
                currentMileage: 10000,
                color: colorName,
              ),
            ),
          ),
        );

        // Verify color text is displayed
        expect(find.text(colorName), findsOneWidget);

        // Verify color circle container exists
        expect(find.byType(Container), findsWidgets);
      }
    });

    testWidgets('displays mileage with correct formatting', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VehicleCard(
              make: 'Tesla',
              model: 'Model 3',
              year: 2022,
              currentMileage: 123456,
            ),
          ),
        ),
      );

      // Verify formatted mileage
      expect(find.text('123456 mi'), findsOneWidget);
    });

    testWidgets('card has proper elevation and styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VehicleCard(
              make: 'BMW',
              model: 'X5',
              year: 2023,
              currentMileage: 5000,
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 2);
    });
  });
}
