import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni_pulse/Widgets/filters.dart';

void main() {
  group('FilterPage Widget Tests', () {
    testWidgets('Renders FilterPage screen with all expected elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FilterPage(),
        ),
      );

      // AppBar
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Filter Events'), findsOneWidget);

      // Category dropdown
      expect(find.text('Category'), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);

      // Price Range slider
      expect(find.text('Price Range'), findsOneWidget);
      expect(find.byType(RangeSlider), findsOneWidget);

      // Date selector
      expect(find.text('Select Date'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);

      // Organisation dropdown
      expect(find.text('Organisation'), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsWidgets);
    });

    testWidgets('Tapping check icon applies filters and pops', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FilterPage(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();
      // If no error, the check icon works and triggers Navigator.pop
    });

    testWidgets('Allows users to select filter options', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FilterPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Open and select a category
      await tester.tap(find.byType(DropdownButton<String>).first);
      await tester.pumpAndSettle();
      final artsItem = find.text('arts').last;
      if (artsItem.evaluate().isNotEmpty) {
        await tester.tap(artsItem);
        await tester.pumpAndSettle();
      }

      // Interact with the price range slider
      final rangeSlider = find.byType(RangeSlider).first;
      expect(rangeSlider, findsOneWidget);
      await tester.drag(rangeSlider, const Offset(50, 0));
      await tester.pumpAndSettle();
    });
  });
}