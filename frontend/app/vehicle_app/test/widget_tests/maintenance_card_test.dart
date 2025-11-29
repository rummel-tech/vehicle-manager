import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_ui/ui_components/maintenance_card.dart';

void main() {
  group('MaintenanceCard Widget Tests', () {
    testWidgets('displays maintenance information correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MaintenanceCard(
              type: 'oil_change',
              date: '2024-01-15',
              mileage: 45000,
              cost: 49.99,
              description: 'Regular oil change with synthetic oil',
              nextDueMileage: 50000,
            ),
          ),
        ),
      );

      // Verify type label
      expect(find.text('Oil Change'), findsOneWidget);

      // Verify date
      expect(find.text('2024-01-15'), findsOneWidget);

      // Verify description
      expect(find.text('Regular oil change with synthetic oil'), findsOneWidget);

      // Verify mileage
      expect(find.text('45000 mi'), findsOneWidget);

      // Verify next due mileage
      expect(find.text('Next: 50000 mi'), findsOneWidget);

      // Verify cost
      expect(find.text('\$49.99'), findsOneWidget);
    });

    testWidgets('displays correct icon for each maintenance type', (WidgetTester tester) async {
      final maintenanceTypes = {
        'oil_change': Icons.oil_barrel,
        'tire_rotation': Icons.album,
        'brake_service': Icons.branding_watermark,
        'inspection': Icons.checklist,
        'repair': Icons.build,
      };

      for (final entry in maintenanceTypes.entries) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MaintenanceCard(
                type: entry.key,
                date: '2024-01-01',
                mileage: 10000,
              ),
            ),
          ),
        );

        // Verify the correct icon is displayed
        expect(find.byIcon(entry.value), findsOneWidget);
      }
    });

    testWidgets('displays correct label for each maintenance type', (WidgetTester tester) async {
      final typeLabels = {
        'oil_change': 'Oil Change',
        'tire_rotation': 'Tire Rotation',
        'brake_service': 'Brake Service',
        'inspection': 'Inspection',
        'repair': 'Repair',
      };

      for (final entry in typeLabels.entries) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MaintenanceCard(
                type: entry.key,
                date: '2024-01-01',
                mileage: 10000,
              ),
            ),
          ),
        );

        // Verify the correct label is displayed
        expect(find.text(entry.value), findsOneWidget);
      }
    });

    testWidgets('displays without optional fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MaintenanceCard(
              type: 'oil_change',
              date: '2024-01-15',
              mileage: 45000,
            ),
          ),
        ),
      );

      // Basic fields should be present
      expect(find.text('Oil Change'), findsOneWidget);
      expect(find.text('2024-01-15'), findsOneWidget);
      expect(find.text('45000 mi'), findsOneWidget);

      // Optional fields should not be present
      expect(find.textContaining('\$'), findsNothing);
      expect(find.textContaining('Next:'), findsNothing);
    });

    testWidgets('handles tap callback', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MaintenanceCard(
              type: 'repair',
              date: '2024-02-01',
              mileage: 50000,
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

    testWidgets('truncates long descriptions with ellipsis', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: MaintenanceCard(
                type: 'repair',
                date: '2024-02-01',
                mileage: 50000,
                description: 'This is a very long description that should be truncated '
                    'because it exceeds the maximum number of lines allowed in the card '
                    'and we want to test the overflow behavior',
              ),
            ),
          ),
        ),
      );

      // Find the Text widget with the description
      final textFinders = find.byType(Text);
      final textWidgets = tester.widgetList<Text>(textFinders);

      // Find the text widget containing the long description
      final descriptionWidget = textWidgets.firstWhere(
        (widget) => widget.data != null && widget.data!.contains('This is a very long description'),
      );

      expect(descriptionWidget.maxLines, 2);
      expect(descriptionWidget.overflow, TextOverflow.ellipsis);
    });

    testWidgets('displays cost with correct formatting', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MaintenanceCard(
              type: 'oil_change',
              date: '2024-01-15',
              mileage: 45000,
              cost: 123.456,
            ),
          ),
        ),
      );

      // Verify cost is formatted to 2 decimal places
      expect(find.text('\$123.46'), findsOneWidget);
    });

    testWidgets('does not display empty description', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MaintenanceCard(
              type: 'oil_change',
              date: '2024-01-15',
              mileage: 45000,
              description: '',
            ),
          ),
        ),
      );

      // Should only find the type and date text widgets
      expect(find.text('Oil Change'), findsOneWidget);
      expect(find.text('2024-01-15'), findsOneWidget);

      // Description should not be visible
      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      expect(textWidgets.where((w) => w.data == ''), isEmpty);
    });
  });
}
